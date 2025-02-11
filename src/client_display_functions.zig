extern fn wl_display_connect(name: ?[*:0]const u8) ?*Display;
pub fn connect(name: ?[*:0]const u8) error{ConnectFailed}!*Display {
    return wl_display_connect(name) orelse return error.ConnectFailed;
}

extern fn wl_display_connect_to_fd(fd: c_int) ?*Display;
pub fn connectToFd(fd: c_int) error{ConnectFailed}!*Display {
    return wl_display_connect_to_fd(fd) orelse return error.ConnectFailed;
}

extern fn wl_display_disconnect(display: *Display) void;
pub const disconnect = wl_display_disconnect;

extern fn wl_display_get_fd(display: *Display) c_int;
pub const getFd = wl_display_get_fd;

extern fn wl_display_dispatch(display: *Display) c_int;
pub fn dispatch(display: *Display) !u32 {
    const rc = wl_display_dispatch(display);
    // poll(2), sendmsg(2), recvmsg(2), EOVERFLOW, E2BIG
    return switch (os.errno(rc)) {
        0 => @intCast(u32, rc),
        os.EFAULT => unreachable,
        os.EINTR => unreachable,
        os.EINVAL => unreachable,
        os.ENOMEM => error.SystemResources,
        os.EACCES => error.AccessDenied,
        os.EAGAIN => unreachable,
        os.EALREADY => error.FastOpenAlreadyInProgress,
        os.EBADF => unreachable,
        os.ECONNRESET => error.ConnectionResetByPeer,
        os.EDESTADDRREQ => unreachable,
        os.EISCONN => unreachable,
        os.EMSGSIZE => error.MessageTooBig,
        os.ENOBUFS => error.SystemResources,
        os.ENOTCONN => unreachable,
        os.ENOTSOCK => unreachable,
        os.EOPNOTSUPP => unreachable,
        os.EPIPE => error.BrokenPipe,
        os.ECONNREFUSED => error.ConnectionRefused,
        os.EOVERFLOW => error.BufferOverflow,
        os.E2BIG => error.BufferOverflow,
        else => |err| os.unexpectedErrno(err),
    };
}

extern fn wl_display_dispatch_queue(display: *Display, queue: *client.wl.EventQueue) c_int;
pub fn dispatchQueue(display: *Display, queue: *client.wl.EventQueue) !u32 {
    const rc = wl_display_dispatch_queue(display, queue);
    return switch (os.errno(rc)) {
        0 => @intCast(u32, rc),
        os.EFAULT => unreachable,
        os.EINTR => unreachable,
        os.EINVAL => unreachable,
        os.ENOMEM => error.SystemResources,
        os.EACCES => error.AccessDenied,
        os.EAGAIN => unreachable,
        os.EALREADY => error.FastOpenAlreadyInProgress,
        os.EBADF => unreachable,
        os.ECONNRESET => error.ConnectionResetByPeer,
        os.EDESTADDRREQ => unreachable,
        os.EISCONN => unreachable,
        os.EMSGSIZE => error.MessageTooBig,
        os.ENOBUFS => error.SystemResources,
        os.ENOTCONN => unreachable,
        os.ENOTSOCK => unreachable,
        os.EOPNOTSUPP => unreachable,
        os.EPIPE => error.BrokenPipe,
        os.ECONNREFUSED => error.ConnectionRefused,
        os.EOVERFLOW => error.BufferOverflow,
        os.E2BIG => error.BufferOverflow,
        else => |err| os.unexpectedErrno(err),
    };
}

extern fn wl_display_dispatch_pending(display: *Display) c_int;
pub fn dispatchPending(display: *Display) !u32 {
    const rc = wl_display_dispatch_pending(display);
    return switch (os.errno(rc)) {
        0 => @intCast(u32, rc),
        // TODO
        else => |err| os.unexpectedErrno(err),
    };
}

extern fn wl_display_dispatch_queue_pending(display: *Display, queue: *client.wl.EventQueue) c_int;
pub fn dispatchQueuePending(display: *Display, queue: *client.wl.EventQueue) !u32 {
    const rc = wl_display_dispatch_queue_pending(display, queue);
    return switch (os.errno(rc)) {
        0 => @intCast(u32, rc),
        // TODO
        else => |err| os.unexpectedErrno(err),
    };
}

extern fn wl_display_roundtrip(display: *Display) c_int;
pub fn roundtrip(display: *Display) !u32 {
    const rc = wl_display_roundtrip(display);
    return switch (os.errno(rc)) {
        0 => @intCast(u32, rc),
        // TODO
        else => |err| os.unexpectedErrno(err),
    };
}

extern fn wl_display_roundtrip_queue(display: *Display, queue: *client.wl.EventQueue) c_int;
pub fn roundtripQueue(display: *Display, queue: *client.wl.EventQueue) !u32 {
    const rc = wl_display_roundtrip_queue(display, queue);
    return switch (os.errno(rc)) {
        0 => @intCast(u32, rc),
        // TODO
        else => |err| os.unexpectedErrno(err),
    };
}

extern fn wl_display_flush(display: *Display) c_int;
pub fn flush(display: *Display) error{WouldBlock}!u32 {
    const rc = wl_display_flush(display);
    return switch (os.errno(rc)) {
        0 => @intCast(u32, rc),
        os.EAGAIN => error.WouldBlock,
        else => unreachable,
    };
}

extern fn wl_display_create_queue(display: *Display) ?*client.wl.EventQueue;
pub fn createQueue(display: *Display) error{OutOfMemory}!*client.wl.EventQueue {
    return wl_display_create_queue(display) orelse error.OutOfMemory;
}

// TODO: should we interpret this return value?
extern fn wl_display_get_error(display: *Display) c_int;
pub const getError = wl_display_get_error;
