#include <stdint.h>
#include <windows.h>
#include <winternl.h>
#include <wine/unixlib.h>
#include "common.h"

// Initialize Wine unixlib.
BOOL WINAPI DllMain(HINSTANCE instance, DWORD reason, LPVOID reserved)
{
	if (reason == DLL_PROCESS_ATTACH)
	{
		/*
		 * Ask Wine to locate and attach this builtin DLL's Unixlib.
		 */
		if (__wine_init_unix_call())
			return FALSE;
	}

	return TRUE;
}

// Proxy to POSIX semaphore functions through Wine unixlib.

// XXX Using void* and just passing thru the pointer is VERY VERY cursed.
void* WINAPI sem_open_native(const char *name, int oflag, unsigned int mode, unsigned int value)
{
	struct sem_open_unix_params params = {
		.name = name,
		.oflag = oflag,
		.mode = mode,
		.value = value,
	};
	NTSTATUS status = WINE_UNIX_CALL(sem_open_unix, &params);

	if (status)
	{
		RtlSetLastWin32Error(status);
		return SHMBRIDGE_SEM_FAILED;
	}
	else if (params.result_handle == SHMBRIDGE_SEM_FAILED)
	{
		RtlSetLastWin32Error(params.errno_out);
	}
	else
	{
		RtlSetLastWin32Error(0);
	}

	return params.result_handle;
}

int WINAPI sem_post_native(void *sem)
{
	struct sem_post_unix_params params = { .handle = sem };
	NTSTATUS status = WINE_UNIX_CALL(sem_post_unix, &params);

	if (status)
	{
		RtlSetLastWin32Error(status);
		return -1;
	}
	else if (params.result < 0)
	{
		RtlSetLastWin32Error(params.errno_out);
	}
	else
	{
		RtlSetLastWin32Error(0);
	}

	return params.result;
}

int WINAPI sem_wait_native(void *sem)
{
	struct sem_wait_unix_params params = { .handle = sem };
	NTSTATUS status = WINE_UNIX_CALL(sem_wait_unix, &params);

	if (status)
	{
		RtlSetLastWin32Error(status);
		return -1;
	}
	else if (params.result < 0)
	{
		RtlSetLastWin32Error(params.errno_out);
	}
	else
	{
		RtlSetLastWin32Error(0);
	}

	return params.result;
}

int WINAPI sem_trywait_native(void *sem)
{
	struct sem_trywait_unix_params params = { .handle = sem };
	NTSTATUS status = WINE_UNIX_CALL(sem_trywait_unix, &params);

	if (status)
	{
		RtlSetLastWin32Error(status);
		return -1;
	}
	else if (params.result < 0)
	{
		RtlSetLastWin32Error(params.errno_out);
	}
	else
	{
		RtlSetLastWin32Error(0);
	}

	return params.result;
}

int WINAPI sem_timedwait_native(void *sem, const struct timespec *restrict abstime)
{
	struct sem_timedwait_unix_params params = {
		.handle = sem,
		.abstime = abstime,
	};
	NTSTATUS status = WINE_UNIX_CALL(sem_timedwait_unix, &params);

	if (status)
	{
		RtlSetLastWin32Error(status);
		return -1;
	}
	else if (params.result < 0)
	{
		RtlSetLastWin32Error(params.errno_out);
	}
	else
	{
		RtlSetLastWin32Error(0);
	}

	return params.result;
}

int WINAPI sem_unlink_native(const char *name)
{
	struct sem_unlink_unix_params params = { .name = name };
	NTSTATUS status = WINE_UNIX_CALL(sem_unlink_unix, &params);

	if (status)
	{
		RtlSetLastWin32Error(status);
		return -1;
	}
	else if (params.result < 0)
	{
		RtlSetLastWin32Error(params.errno_out);
	}
	else
	{
		RtlSetLastWin32Error(0);
	}

	return params.result;
}

int WINAPI sem_close_native(void *sem)
{
	struct sem_close_unix_params params = { .handle = sem };
	NTSTATUS status = WINE_UNIX_CALL(sem_close_unix, &params);

	if (status)
	{
		RtlSetLastWin32Error(status);
		return -1;
	}
	else if (params.result < 0)
	{
		RtlSetLastWin32Error(params.errno_out);
	}
	else
	{
		RtlSetLastWin32Error(0);
	}

	return params.result;
}
