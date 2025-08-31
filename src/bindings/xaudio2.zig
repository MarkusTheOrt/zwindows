const std = @import("std");
const windows = @import("windows.zig");
const IUnknown = windows.IUnknown;
const BYTE = windows.BYTE;
const UINT = windows.UINT;
const UINT32 = windows.UINT32;
const UINT64 = windows.UINT64;
const WINAPI = windows.WINAPI;
const LPCWSTR = windows.LPCWSTR;
const BOOL = windows.BOOL;
const DWORD = windows.DWORD;
const GUID = windows.GUID;
const HRESULT = windows.HRESULT;
const WAVEFORMATEX = @import("wasapi.zig").WAVEFORMATEX;

// NOTE(mziulek):
// xaudio2redist.h uses tight field packing so we need align each field with `align(1)`
// in all non-interface structure definitions.

pub const COMMIT_NOW = 0;
pub const COMMIT_ALL = 0;
pub const INVALID_OPSET = 0xffff_ffff;
pub const NO_LOOP_REGION = 0;
pub const LOOP_INFINITE = 255;
pub const DEFAULT_CHANNELS = 0;
pub const DEFAULT_SAMPLERATE = 0;

pub const MAX_BUFFER_BYTES = 0x8000_0000;
pub const MAX_QUEUED_BUFFERS = 64;
pub const MAX_BUFFERS_SYSTEM = 2;
pub const MAX_AUDIO_CHANNELS = 64;
pub const MIN_SAMPLE_RATE = 1000;
pub const MAX_SAMPLE_RATE = 200000;
pub const MAX_VOLUME_LEVEL = 16777216.0;
pub const MIN_FREQ_RATIO = 1.0 / 1024.0;
pub const MAX_FREQ_RATIO = 1024.0;
pub const DEFAULT_FREQ_RATIO = 2.0;
pub const MAX_FILTER_ONEOVERQ = 1.5;
pub const MAX_FILTER_FREQUENCY = 1.0;
pub const MAX_LOOP_COUNT = 254;
pub const MAX_INSTANCES = 8;

pub const FLAGS = packed struct(UINT32) {
    DEBUG_ENGINE: bool = false,
    VOICE_NOPITCH: bool = false,
    VOICE_NOSRC: bool = false,
    VOICE_USEFILTER: bool = false,
    __unused4: bool = false,
    PLAY_TAILS: bool = false,
    END_OF_STREAM: bool = false,
    SEND_USEFILTER: bool = false,
    VOICE_NOSAMPLESPLAYED: bool = false,
    __unused9: bool = false,
    __unused10: bool = false,
    __unused11: bool = false,
    __unused12: bool = false,
    STOP_ENGINE_WHEN_IDLE: bool = false,
    __unused14: bool = false,
    @"1024_QUANTUM": bool = false,
    NO_VIRTUAL_AUDIO_CLIENT: bool = false,
    __unused: u15 = 0,
};

pub const VOICE_DETAILS = extern struct {
    CreationFlags: FLAGS align(1),
    ActiveFlags: FLAGS align(1),
    InputChannels: UINT32 align(1),
    InputSampleRate: UINT32 align(1),
};

pub const SEND_DESCRIPTOR = extern struct {
    Flags: FLAGS align(1),
    pOutputVoice: *IVoice align(1),
};

pub const VOICE_SENDS = extern struct {
    SendCount: UINT32 align(1),
    pSends: [*]SEND_DESCRIPTOR align(1),
};

pub const EFFECT_DESCRIPTOR = extern struct {
    pEffect: *IUnknown align(1),
    InitialState: BOOL align(1),
    OutputChannels: UINT32 align(1),
};

pub const EFFECT_CHAIN = extern struct {
    EffectCount: UINT32 align(1),
    pEffectDescriptors: [*]EFFECT_DESCRIPTOR align(1),
};

pub const FILTER_TYPE = enum(UINT32) {
    LowPassFilter,
    BandPassFilter,
    HighPassFilter,
    NotchFilter,
    LowPassOnePoleFilter,
    HighPassOnePoleFilter,
};

pub const AUDIO_STREAM_CATEGORY = enum(UINT32) {
    Other = 0,
    ForegroundOnlyMedia = 1,
    Communications = 3,
    Alerts = 4,
    SoundEffects = 5,
    GameEffects = 6,
    GameMedia = 7,
    GameChat = 8,
    Speech = 9,
    Movie = 10,
    Media = 11,
};

pub const FILTER_PARAMETERS = extern struct {
    Type: FILTER_TYPE align(1),
    Frequency: f32 align(1),
    OneOverQ: f32 align(1),
};

pub const BUFFER = extern struct {
    Flags: FLAGS align(1),
    AudioBytes: UINT32 align(1),
    pAudioData: [*]const BYTE align(1),
    PlayBegin: UINT32 align(1),
    PlayLength: UINT32 align(1),
    LoopBegin: UINT32 align(1),
    LoopLength: UINT32 align(1),
    LoopCount: UINT32 align(1),
    pContext: ?*anyopaque align(1),
};

pub const BUFFER_WMA = extern struct {
    pDecodedPacketCumulativeBytes: *const UINT32 align(1),
    PacketCount: UINT32 align(1),
};

pub const VOICE_STATE = extern struct {
    pCurrentBufferContext: ?*anyopaque align(1),
    BuffersQueued: UINT32 align(1),
    SamplesPlayed: UINT64 align(1),
};

pub const PERFORMANCE_DATA = extern struct {
    AudioCyclesSinceLastQuery: UINT64 align(1),
    TotalCyclesSinceLastQuery: UINT64 align(1),
    MinimumCyclesPerQuantum: UINT32 align(1),
    MaximumCyclesPerQuantum: UINT32 align(1),
    MemoryUsageInBytes: UINT32 align(1),
    CurrentLatencyInSamples: UINT32 align(1),
    GlitchesSinceEngineStarted: UINT32 align(1),
    ActiveSourceVoiceCount: UINT32 align(1),
    TotalSourceVoiceCount: UINT32 align(1),
    ActiveSubmixVoiceCount: UINT32 align(1),
    ActiveResamplerCount: UINT32 align(1),
    ActiveMatrixMixCount: UINT32 align(1),
    ActiveXmaSourceVoices: UINT32 align(1),
    ActiveXmaStreams: UINT32 align(1),
};

pub const LOG_FLAGS = packed struct(UINT32) {
    ERRORS: bool = false,
    WARNINGS: bool = false,
    INFO: bool = false,
    DETAIL: bool = false,
    API_CALLS: bool = false,
    FUNC_CALLS: bool = false,
    TIMING: bool = false,
    LOCKS: bool = false,
    MEMORY: bool = false,
    __unused9: bool = false,
    __unused10: bool = false,
    __unused11: bool = false,
    STREAMING: bool = false,
    __unused: u19 = 0,
};

pub const DEBUG_CONFIGURATION = extern struct {
    TraceMask: LOG_FLAGS align(1),
    BreakMask: LOG_FLAGS align(1),
    LogThreadID: BOOL align(1),
    LogFileline: BOOL align(1),
    LogFunctionName: BOOL align(1),
    LogTiming: BOOL align(1),
};

pub const IXAudio2 = extern struct {
    __v: *const VTable,

    unknown: IUnknown.Interface(@This()) = .{},
    xaudio: Interface(@This()) = .{},

    pub fn Interface(comptime T: type) type {
        return extern struct {
            pub inline fn RegisterForCallbacks(self: *@This(), cb: *IEngineCallback) HRESULT {
                const parent: *T = @alignCast(@fieldParentPtr("xaudio", self));
                return @as(*const IXAudio2.VTable, @ptrCast(parent.__v))
                    .RegisterForCallbacks(@as(*IXAudio2, @ptrCast(parent)), cb);
            }
            pub inline fn UnregisterForCallbacks(self: *@This(), cb: *IEngineCallback) void {
                const parent: *T = @alignCast(@fieldParentPtr("xaudio", self));
                @as(*const IXAudio2.VTable, @ptrCast(parent.__v))
                    .UnregisterForCallbacks(@as(*IXAudio2, @ptrCast(parent)), cb);
            }
            pub inline fn CreateSourceVoice(
                self: *@This(),
                source_voice: *?*ISourceVoice,
                source_format: *const WAVEFORMATEX,
                flags: FLAGS,
                max_frequency_ratio: f32,
                callback: ?*IVoiceCallback,
                send_list: ?*const VOICE_SENDS,
                effect_chain: ?*const EFFECT_CHAIN,
            ) HRESULT {
                const parent: *T = @alignCast(@fieldParentPtr("xaudio", self));
                return @as(*const IXAudio2.VTable, @ptrCast(parent.__v)).CreateSourceVoice(
                    @as(*IXAudio2, @ptrCast(parent)),
                    source_voice,
                    source_format,
                    flags,
                    max_frequency_ratio,
                    callback,
                    send_list,
                    effect_chain,
                );
            }
            pub inline fn CreateSubmixVoice(
                self: *@This(),
                submix_voice: *?*ISubmixVoice,
                input_channels: UINT32,
                input_sample_rate: UINT32,
                flags: FLAGS,
                processing_stage: UINT32,
                send_list: ?*const VOICE_SENDS,
                effect_chain: ?*const EFFECT_CHAIN,
            ) HRESULT {
                const parent: *T = @alignCast(@fieldParentPtr("xaudio", self));
                return @as(*const IXAudio2.VTable, @ptrCast(parent.__v)).CreateSubmixVoice(
                    @as(*IXAudio2, @ptrCast(parent)),
                    submix_voice,
                    input_channels,
                    input_sample_rate,
                    flags,
                    processing_stage,
                    send_list,
                    effect_chain,
                );
            }
            pub inline fn CreateMasteringVoice(
                self: *@This(),
                mastering_voice: *?*IMasteringVoice,
                input_channels: UINT32,
                input_sample_rate: UINT32,
                flags: FLAGS,
                device_id: ?LPCWSTR,
                effect_chain: ?*const EFFECT_CHAIN,
                stream_category: AUDIO_STREAM_CATEGORY,
            ) HRESULT {
                const parent: *T = @alignCast(@fieldParentPtr("xaudio", self));
                return @as(*const IXAudio2.VTable, @ptrCast(parent.__v)).CreateMasteringVoice(
                    @as(*IXAudio2, @ptrCast(parent)),
                    mastering_voice,
                    input_channels,
                    input_sample_rate,
                    flags,
                    device_id,
                    effect_chain,
                    stream_category,
                );
            }
            pub inline fn StartEngine(self: *@This()) HRESULT {
                const parent: *T = @alignCast(@fieldParentPtr("xaudio", self));
                return @as(*const IXAudio2.VTable, @ptrCast(parent.__v))
                    .StartEngine(@as(*IXAudio2, @ptrCast(parent)));
            }
            pub inline fn StopEngine(self: *@This()) void {
                const parent: *T = @alignCast(@fieldParentPtr("xaudio", self));
                @as(*const IXAudio2.VTable, @ptrCast(parent.__v)).StopEngine(@as(*IXAudio2, @ptrCast(parent)));
            }
            pub inline fn CommitChanges(self: *@This(), operation_set: UINT32) HRESULT {
                const parent: *T = @alignCast(@fieldParentPtr("xaudio", self));
                return @as(*const IXAudio2.VTable, @ptrCast(parent.__v))
                    .CommitChanges(@as(*IXAudio2, @ptrCast(parent)), operation_set);
            }
            pub inline fn GetPerformanceData(self: *@This(), data: *PERFORMANCE_DATA) void {
                const parent: *T = @alignCast(@fieldParentPtr("xaudio", self));
                @as(*const IXAudio2.VTable, @ptrCast(parent.__v))
                    .GetPerformanceData(@as(*IXAudio2, @ptrCast(parent)), data);
            }
            pub inline fn SetDebugConfiguration(
                self: *@This(),
                config: ?*const DEBUG_CONFIGURATION,
                reserved: ?*anyopaque,
            ) void {
                const parent: *T = @alignCast(@fieldParentPtr("xaudio", self));
                @as(*const IXAudio2.VTable, @ptrCast(parent.__v))
                    .SetDebugConfiguration(@as(*IXAudio2, @ptrCast(parent)), config, reserved);
            }
        };
    }

    pub const VTable = extern struct {
        const T = IXAudio2;
        base: IUnknown.VTable,
        RegisterForCallbacks: *const fn (*T, *IEngineCallback) callconv(WINAPI) HRESULT,
        UnregisterForCallbacks: *const fn (*T, *IEngineCallback) callconv(WINAPI) void,
        CreateSourceVoice: *const fn (
            *T,
            *?*ISourceVoice,
            *const WAVEFORMATEX,
            FLAGS,
            f32,
            ?*IVoiceCallback,
            ?*const VOICE_SENDS,
            ?*const EFFECT_CHAIN,
        ) callconv(WINAPI) HRESULT,
        CreateSubmixVoice: *const fn (
            *T,
            *?*ISubmixVoice,
            UINT32,
            UINT32,
            FLAGS,
            UINT32,
            ?*const VOICE_SENDS,
            ?*const EFFECT_CHAIN,
        ) callconv(WINAPI) HRESULT,
        CreateMasteringVoice: *const fn (
            *T,
            *?*IMasteringVoice,
            UINT32,
            UINT32,
            FLAGS,
            ?LPCWSTR,
            ?*const EFFECT_CHAIN,
            AUDIO_STREAM_CATEGORY,
        ) callconv(WINAPI) HRESULT,
        StartEngine: *const fn (*T) callconv(WINAPI) HRESULT,
        StopEngine: *const fn (*T) callconv(WINAPI) void,
        CommitChanges: *const fn (*T, UINT32) callconv(WINAPI) HRESULT,
        GetPerformanceData: *const fn (*T, *PERFORMANCE_DATA) callconv(WINAPI) void,
        SetDebugConfiguration: *const fn (
            *T,
            ?*const DEBUG_CONFIGURATION,
            ?*anyopaque,
        ) callconv(WINAPI) void,
    };
};

pub const IVoice = extern struct {
    __v: *const VTable,

    voice: Interface(@This()) = .{},

    pub fn Interface(comptime T: type) type {
        return extern struct {
            pub inline fn GetVoiceDetails(self: *@This(), details: *VOICE_DETAILS) void {
                const parent: *T = @alignCast(@fieldParentPtr("voice", self));
                @as(*const IVoice.VTable, @ptrCast(parent.__v))
                    .GetVoiceDetails(@as(*IVoice, @ptrCast(parent)), details);
            }
            pub inline fn SetOutputVoices(self: *@This(), send_list: ?*const VOICE_SENDS) HRESULT {
                const parent: *T = @alignCast(@fieldParentPtr("voice", self));
                return @as(*const IVoice.VTable, @ptrCast(parent.__v))
                    .SetOutputVoices(@as(*IVoice, @ptrCast(parent)), send_list);
            }
            pub inline fn SetEffectChain(self: *@This(), effect_chain: ?*const EFFECT_CHAIN) HRESULT {
                const parent: *T = @alignCast(@fieldParentPtr("voice", self));
                return @as(*const IVoice.VTable, @ptrCast(parent.__v))
                    .SetEffectChain(@as(*IVoice, @ptrCast(parent)), effect_chain);
            }
            pub inline fn EnableEffect(self: *@This(), effect_index: UINT32, operation_set: UINT32) HRESULT {
                const parent: *T = @alignCast(@fieldParentPtr("voice", self));
                return @as(*const IVoice.VTable, @ptrCast(parent.__v))
                    .EnableEffect(@as(*IVoice, @ptrCast(parent)), effect_index, operation_set);
            }
            pub inline fn DisableEffect(self: *@This(), effect_index: UINT32, operation_set: UINT32) HRESULT {
                const parent: *T = @alignCast(@fieldParentPtr("voice", self));
                return @as(*const IVoice.VTable, @ptrCast(parent.__v))
                    .DisableEffect(@as(*IVoice, @ptrCast(parent)), effect_index, operation_set);
            }
            pub inline fn GetEffectState(self: *@This(), effect_index: UINT32, enabled: *BOOL) void {
                const parent: *T = @alignCast(@fieldParentPtr("voice", self));
                @as(*const IVoice.VTable, @ptrCast(parent.__v))
                    .GetEffectState(@as(*IVoice, @ptrCast(parent)), effect_index, enabled);
            }
            pub inline fn SetEffectParameters(
                self: *@This(),
                effect_index: UINT32,
                params: *const anyopaque,
                params_size: UINT32,
                operation_set: UINT32,
            ) HRESULT {
                const parent: *T = @alignCast(@fieldParentPtr("voice", self));
                return @as(*const IVoice.VTable, @ptrCast(parent.__v)).SetEffectParameters(
                    @as(*IVoice, @ptrCast(parent)),
                    effect_index,
                    params,
                    params_size,
                    operation_set,
                );
            }
            pub inline fn GetEffectParameters(
                self: *@This(),
                effect_index: UINT32,
                params: *anyopaque,
                params_size: UINT32,
            ) HRESULT {
                const parent: *T = @alignCast(@fieldParentPtr("voice", self));
                return @as(*const IVoice.VTable, @ptrCast(parent.__v))
                    .GetEffectParameters(@as(*IVoice, @ptrCast(parent)), effect_index, params, params_size);
            }
            pub inline fn SetFilterParameters(
                self: *@This(),
                params: *const FILTER_PARAMETERS,
                operation_set: UINT32,
            ) HRESULT {
                const parent: *T = @alignCast(@fieldParentPtr("voice", self));
                return @as(*const IVoice.VTable, @ptrCast(parent.__v))
                    .SetFilterParameters(@as(*IVoice, @ptrCast(parent)), params, operation_set);
            }
            pub inline fn GetFilterParameters(self: *@This(), params: *FILTER_PARAMETERS) void {
                const parent: *T = @alignCast(@fieldParentPtr("voice", self));
                @as(*const IVoice.VTable, @ptrCast(parent.__v))
                    .GetFilterParameters(@as(*IVoice, @ptrCast(parent)), params);
            }
            pub inline fn SetOutputFilterParameters(
                self: *@This(),
                dst_voice: ?*IVoice,
                params: *const FILTER_PARAMETERS,
                operation_set: UINT32,
            ) HRESULT {
                const parent: *T = @alignCast(@fieldParentPtr("voice", self));
                return @as(*const IVoice.VTable, @ptrCast(parent.__v))
                    .SetOutputFilterParameters(@as(*IVoice, @ptrCast(parent)), dst_voice, params, operation_set);
            }
            pub inline fn GetOutputFilterParameters(
                self: *@This(),
                dst_voice: ?*IVoice,
                params: *FILTER_PARAMETERS,
            ) void {
                const parent: *T = @alignCast(@fieldParentPtr("voice", self));
                @as(*const IVoice.VTable, @ptrCast(parent.__v))
                    .GetOutputFilterParameters(@as(*IVoice, @ptrCast(parent)), dst_voice, params);
            }
            pub inline fn SetVolume(self: *@This(), volume: f32) HRESULT {
                const parent: *T = @alignCast(@fieldParentPtr("voice", self));
                return @as(*const IVoice.VTable, @ptrCast(parent.__v)).SetVolume(@as(*IVoice, @ptrCast(parent)), volume);
            }
            pub inline fn GetVolume(self: *@This(), volume: *f32) void {
                const parent: *T = @alignCast(@fieldParentPtr("voice", self));
                @as(*const IVoice.VTable, @ptrCast(parent.__v)).GetVolume(@as(*IVoice, @ptrCast(parent)), volume);
            }
            pub inline fn SetChannelVolumes(
                self: *@This(),
                num_channels: UINT32,
                volumes: [*]const f32,
                operation_set: UINT32,
            ) HRESULT {
                const parent: *T = @alignCast(@fieldParentPtr("voice", self));
                return @as(*const IVoice.VTable, @ptrCast(parent.__v))
                    .SetChannelVolumes(@as(*IVoice, @ptrCast(parent)), num_channels, volumes, operation_set);
            }
            pub inline fn GetChannelVolumes(self: *@This(), num_channels: UINT32, volumes: [*]f32) void {
                const parent: *T = @alignCast(@fieldParentPtr("voice", self));
                @as(*const IVoice.VTable, @ptrCast(parent.__v))
                    .GetChannelVolumes(@as(*IVoice, @ptrCast(parent)), num_channels, volumes);
            }
            pub inline fn DestroyVoice(self: *@This()) void {
                const parent: *T = @alignCast(@fieldParentPtr("voice", self));
                @as(*const IVoice.VTable, @ptrCast(parent.__v)).DestroyVoice(@as(*IVoice, @ptrCast(parent)));
            }
        };
    }

    pub const VTable = extern struct {
        const T = IVoice;
        GetVoiceDetails: *const fn (*T, *VOICE_DETAILS) callconv(WINAPI) void,
        SetOutputVoices: *const fn (*T, ?*const VOICE_SENDS) callconv(WINAPI) HRESULT,
        SetEffectChain: *const fn (*T, ?*const EFFECT_CHAIN) callconv(WINAPI) HRESULT,
        EnableEffect: *const fn (*T, UINT32, UINT32) callconv(WINAPI) HRESULT,
        DisableEffect: *const fn (*T, UINT32, UINT32) callconv(WINAPI) HRESULT,
        GetEffectState: *const fn (*T, UINT32, *BOOL) callconv(WINAPI) void,
        SetEffectParameters: *const fn (
            *T,
            UINT32,
            *const anyopaque,
            UINT32,
            UINT32,
        ) callconv(WINAPI) HRESULT,
        GetEffectParameters: *const fn (*T, UINT32, *anyopaque, UINT32) callconv(WINAPI) HRESULT,
        SetFilterParameters: *const fn (
            *T,
            *const FILTER_PARAMETERS,
            UINT32,
        ) callconv(WINAPI) HRESULT,
        GetFilterParameters: *const fn (*T, *FILTER_PARAMETERS) callconv(WINAPI) void,
        SetOutputFilterParameters: *const fn (
            *T,
            ?*IVoice,
            *const FILTER_PARAMETERS,
            UINT32,
        ) callconv(WINAPI) HRESULT,
        GetOutputFilterParameters: *const fn (*T, ?*IVoice, *FILTER_PARAMETERS) callconv(WINAPI) void,
        SetVolume: *const fn (*T, f32) callconv(WINAPI) HRESULT,
        GetVolume: *const fn (*T, *f32) callconv(WINAPI) void,
        SetChannelVolumes: *const fn (*T, UINT32, [*]const f32, UINT32) callconv(WINAPI) HRESULT,
        GetChannelVolumes: *const fn (*T, UINT32, [*]f32) callconv(WINAPI) void,
        SetOutputMatrix: *anyopaque,
        GetOutputMatrix: *anyopaque,
        DestroyVoice: *const fn (*T) callconv(WINAPI) void,
    };
};

pub const ISourceVoice = extern struct {
    __v: *const VTable,

    voice: IVoice.Interface(@This()) = .{},
    source_voice: Interface(@This()) = .{},

    pub fn Interface(comptime T: type) type {
        return extern struct {
            pub inline fn Start(self: *@This(), flags: FLAGS, operation_set: UINT32) HRESULT {
                const parent: *T = @alignCast(@fieldParentPtr("source_voice", self));
                return @as(*const ISourceVoice.VTable, @ptrCast(parent.__v))
                    .Start(@as(*ISourceVoice, @ptrCast(parent)), flags, operation_set);
            }
            pub inline fn Stop(self: *@This(), flags: FLAGS, operation_set: UINT32) HRESULT {
                const parent: *T = @alignCast(@fieldParentPtr("source_voice", self));
                return @as(*const ISourceVoice.VTable, @ptrCast(parent.__v))
                    .Stop(@as(*ISourceVoice, @ptrCast(parent)), flags, operation_set);
            }
            pub inline fn SubmitSourceBuffer(
                self: *@This(),
                buffer: *const BUFFER,
                wmabuffer: ?*const BUFFER_WMA,
            ) HRESULT {
                const parent: *T = @alignCast(@fieldParentPtr("source_voice", self));
                return @as(*const ISourceVoice.VTable, @ptrCast(parent.__v))
                    .SubmitSourceBuffer(@as(*ISourceVoice, @ptrCast(parent)), buffer, wmabuffer);
            }
            pub inline fn FlushSourceBuffers(self: *@This()) HRESULT {
                const parent: *T = @alignCast(@fieldParentPtr("source_voice", self));
                return @as(*const ISourceVoice.VTable, @ptrCast(parent.__v))
                    .FlushSourceBuffers(@as(*ISourceVoice, @ptrCast(parent)));
            }
            pub inline fn Discontinuity(self: *@This()) HRESULT {
                const parent: *T = @alignCast(@fieldParentPtr("source_voice", self));
                return @as(*const ISourceVoice.VTable, @ptrCast(parent.__v))
                    .Discontinuity(@as(*ISourceVoice, @ptrCast(parent)));
            }
            pub inline fn ExitLoop(self: *@This(), operation_set: UINT32) HRESULT {
                const parent: *T = @alignCast(@fieldParentPtr("source_voice", self));
                return @as(*const ISourceVoice.VTable, @ptrCast(parent.__v))
                    .ExitLoop(@as(*ISourceVoice, @ptrCast(parent)), operation_set);
            }
            pub inline fn GetState(self: *@This(), state: *VOICE_STATE, flags: FLAGS) void {
                const parent: *T = @alignCast(@fieldParentPtr("source_voice", self));
                @as(*const ISourceVoice.VTable, @ptrCast(parent.__v))
                    .GetState(@as(*ISourceVoice, @ptrCast(parent)), state, flags);
            }
            pub inline fn SetFrequencyRatio(self: *@This(), ratio: f32, operation_set: UINT32) HRESULT {
                const parent: *T = @alignCast(@fieldParentPtr("source_voice", self));
                return @as(*const ISourceVoice.VTable, @ptrCast(parent.__v))
                    .SetFrequencyRatio(@as(*ISourceVoice, @ptrCast(parent)), ratio, operation_set);
            }
            pub inline fn GetFrequencyRatio(self: *@This(), ratio: *f32) void {
                const parent: *T = @alignCast(@fieldParentPtr("source_voice", self));
                @as(*const ISourceVoice.VTable, @ptrCast(parent.__v))
                    .GetFrequencyRatio(@as(*ISourceVoice, @ptrCast(parent)), ratio);
            }
            pub inline fn SetSourceSampleRate(self: *@This(), sample_rate: UINT32) HRESULT {
                const parent: *T = @alignCast(@fieldParentPtr("source_voice", self));
                return @as(*const ISourceVoice.VTable, @ptrCast(parent.__v))
                    .SetSourceSampleRate(@as(*ISourceVoice, @ptrCast(parent)), sample_rate);
            }
        };
    }

    pub const VTable = extern struct {
        const T = ISourceVoice;
        base: IVoice.VTable,
        Start: *const fn (*T, FLAGS, UINT32) callconv(WINAPI) HRESULT,
        Stop: *const fn (*T, FLAGS, UINT32) callconv(WINAPI) HRESULT,
        SubmitSourceBuffer: *const fn (
            *T,
            *const BUFFER,
            ?*const BUFFER_WMA,
        ) callconv(WINAPI) HRESULT,
        FlushSourceBuffers: *const fn (*T) callconv(WINAPI) HRESULT,
        Discontinuity: *const fn (*T) callconv(WINAPI) HRESULT,
        ExitLoop: *const fn (*T, UINT32) callconv(WINAPI) HRESULT,
        GetState: *const fn (*T, *VOICE_STATE, FLAGS) callconv(WINAPI) void,
        SetFrequencyRatio: *const fn (*T, f32, UINT32) callconv(WINAPI) HRESULT,
        GetFrequencyRatio: *const fn (*T, *f32) callconv(WINAPI) void,
        SetSourceSampleRate: *const fn (*T, UINT32) callconv(WINAPI) HRESULT,
    };
};

pub const ISubmixVoice = extern struct {
    __v: *const VTable,

    voice: IVoice.Interface(@This()) = .{},

    pub const VTable = extern struct {
        base: IVoice.VTable,
    };
};

pub const IMasteringVoice = extern struct {
    __v: *const VTable,

    voice: IVoice.Interface(@This()) = .{},
    mastering_voice: Interface(@This()) = .{},

    pub fn Interface(comptime T: type) type {
        return extern struct {
            pub inline fn GetChannelMask(self: *@This(), channel_mask: *DWORD) HRESULT {
                const parent: *T = @alignCast(@fieldParentPtr("mastering_voice", self));
                return @as(*const IMasteringVoice.VTable, @ptrCast(parent.__v))
                    .GetChannelMask(@as(*IMasteringVoice, @ptrCast(parent)), channel_mask);
            }
        };
    }

    pub const VTable = extern struct {
        base: IVoice.VTable,
        GetChannelMask: *const fn (*IMasteringVoice, *DWORD) callconv(WINAPI) HRESULT,
    };
};

pub const IEngineCallback = extern struct {
    __v: *const VTable,

    engine_callback: Interface(@This()) = .{},

    pub fn Interface(comptime T: type) type {
        return extern struct {
            pub inline fn OnProcessingPassStart(self: *@This()) void {
                const parent: *T = @alignCast(@fieldParentPtr("engine_callback", self));
                @as(*const IEngineCallback.VTable, @ptrCast(parent.__v))
                    .OnProcessingPassStart(@as(*IEngineCallback, @ptrCast(parent)));
            }
            pub inline fn OnProcessingPassEnd(self: *@This()) void {
                const parent: *T = @alignCast(@fieldParentPtr("engine_callback", self));
                @as(*const IEngineCallback.VTable, @ptrCast(parent.__v))
                    .OnProcessingPassEnd(@as(*IEngineCallback, @ptrCast(parent)));
            }
            pub inline fn OnCriticalError(self: *@This(), err: HRESULT) void {
                const parent: *T = @alignCast(@fieldParentPtr("engine_callback", self));
                @as(*const IEngineCallback.VTable, @ptrCast(parent.__v))
                    .OnCriticalError(@as(*IEngineCallback, @ptrCast(parent)), err);
            }
        };
    }

    pub const VTable = extern struct {
        OnProcessingPassStart: *const fn (*IEngineCallback) callconv(WINAPI) void = _onProcessingPassStart,

        OnProcessingPassEnd: *const fn (*IEngineCallback) callconv(WINAPI) void = _onProcessingPassEnd,

        OnCriticalError: *const fn (*IEngineCallback, HRESULT) callconv(WINAPI) void = _onCriticalError,
    };

    // Default implementations
    fn _onProcessingPassStart(_: *IEngineCallback) callconv(WINAPI) void {}
    fn _onProcessingPassEnd(_: *IEngineCallback) callconv(WINAPI) void {}
    fn _onCriticalError(_: *IEngineCallback, _: HRESULT) callconv(WINAPI) void {}
};

pub const IVoiceCallback = extern struct {
    __v: *const VTable,

    voice_callback: Interface(@This()) = .{},

    pub fn Interface(comptime T: type) type {
        return extern struct {
            pub inline fn OnVoiceProcessingPassStart(self: *@This(), bytes_required: UINT32) void {
                const parent: *T = @alignCast(@fieldParentPtr("voice_callback", self));
                @as(*const IVoiceCallback.VTable, @ptrCast(parent.__v))
                    .OnVoiceProcessingPassStart(@as(*IVoiceCallback, @ptrCast(parent)), bytes_required);
            }
            pub inline fn OnVoiceProcessingPassEnd(self: *@This()) void {
                const parent: *T = @alignCast(@fieldParentPtr("voice_callback", self));
                @as(*const IVoiceCallback.VTable, @ptrCast(parent.__v))
                    .OnVoiceProcessingPassEnd(@as(*IVoiceCallback, @ptrCast(parent)));
            }
            pub inline fn OnStreamEnd(self: *@This()) void {
                const parent: *T = @alignCast(@fieldParentPtr("voice_callback", self));
                @as(*const IVoiceCallback.VTable, @ptrCast(parent.__v))
                    .OnStreamEnd(@as(*IVoiceCallback, @ptrCast(parent)));
            }
            pub inline fn OnBufferStart(self: *@This(), context: ?*anyopaque) void {
                const parent: *T = @alignCast(@fieldParentPtr("voice_callback", self));
                @as(*const IVoiceCallback.VTable, @ptrCast(parent.__v))
                    .OnBufferStart(@as(*IVoiceCallback, @ptrCast(parent)), context);
            }
            pub inline fn OnBufferEnd(self: *@This(), context: ?*anyopaque) void {
                const parent: *T = @alignCast(@fieldParentPtr("voice_callback", self));
                @as(*const IVoiceCallback.VTable, @ptrCast(parent.__v))
                    .OnBufferEnd(@as(*IVoiceCallback, @ptrCast(parent)), context);
            }
            pub inline fn OnLoopEnd(self: *@This(), context: ?*anyopaque) void {
                const parent: *T = @alignCast(@fieldParentPtr("voice_callback", self));
                @as(*const IVoiceCallback.VTable, @ptrCast(parent.__v))
                    .OnLoopEnd(@as(*IVoiceCallback, @ptrCast(parent)), context);
            }
            pub inline fn OnVoiceError(self: *@This(), context: ?*anyopaque, err: HRESULT) void {
                const parent: *T = @alignCast(@fieldParentPtr("voice_callback", self));
                @as(*const IVoiceCallback.VTable, @ptrCast(parent.__v))
                    .OnVoiceError(@as(*IVoiceCallback, @ptrCast(parent)), context, err);
            }
        };
    }

    pub const VTable = extern struct {
        OnVoiceProcessingPassStart: *const fn (*IVoiceCallback, UINT32) callconv(WINAPI) void =
            _onVoiceProcessingPassStart,

        OnVoiceProcessingPassEnd: *const fn (*IVoiceCallback) callconv(WINAPI) void =
            _onVoiceProcessingPassEnd,

        OnStreamEnd: *const fn (*IVoiceCallback) callconv(WINAPI) void = _onStreamEnd,

        OnBufferStart: *const fn (*IVoiceCallback, ?*anyopaque) callconv(WINAPI) void = _onBufferStart,

        OnBufferEnd: *const fn (*IVoiceCallback, ?*anyopaque) callconv(WINAPI) void = _onBufferEnd,

        OnLoopEnd: *const fn (*IVoiceCallback, ?*anyopaque) callconv(WINAPI) void = _onLoopEnd,

        OnVoiceError: *const fn (*IVoiceCallback, ?*anyopaque, HRESULT) callconv(WINAPI) void = _onVoiceError,
    };

    // Default implementations
    fn _onVoiceProcessingPassStart(_: *IVoiceCallback, _: UINT32) callconv(WINAPI) void {}
    fn _onVoiceProcessingPassEnd(_: *IVoiceCallback) callconv(WINAPI) void {}
    fn _onStreamEnd(_: *IVoiceCallback) callconv(WINAPI) void {}
    fn _onBufferStart(_: *IVoiceCallback, _: ?*anyopaque) callconv(WINAPI) void {}
    fn _onBufferEnd(_: *IVoiceCallback, _: ?*anyopaque) callconv(WINAPI) void {}
    fn _onLoopEnd(_: *IVoiceCallback, _: ?*anyopaque) callconv(WINAPI) void {}
    fn _onVoiceError(_: *IVoiceCallback, _: ?*anyopaque, _: HRESULT) callconv(WINAPI) void {}
};

pub fn create(
    ppv: *?*IXAudio2,
    flags: FLAGS, // .{}
    processor: UINT32, // 0
) HRESULT {
    var xaudio2_dll = windows.GetModuleHandleA("xaudio2_9redist.dll");
    if (xaudio2_dll == null) {
        xaudio2_dll = windows.LoadLibraryA("xaudio2_9redist.dll");
    }

    var xaudio2Create: *const fn (*?*IXAudio2, FLAGS, UINT32) callconv(WINAPI) HRESULT = undefined;
    xaudio2Create = @as(
        @TypeOf(xaudio2Create),
        @ptrCast(windows.GetProcAddress(xaudio2_dll.?, "XAudio2Create").?),
    );

    return xaudio2Create(ppv, flags, processor);
}
