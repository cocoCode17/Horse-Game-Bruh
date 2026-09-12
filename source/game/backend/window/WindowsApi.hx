package game.backend.window;

#if windows
@:cppFileCode('
#include <windows.h>
#include <dwmapi.h>
#pragma comment(lib, "dwmapi.lib")
')
#end
#if windows
@:headerCode('
#ifndef WIN32_LEAN_AND_MEAN
#define WIN32_LEAN_AND_MEAN
#endif
#include <windows.h>
#include <shellapi.h>

#pragma comment(lib, "shell32.lib")

#undef BLACK
#undef WHITE
#undef RED
#undef GREEN
#undef BLUE
#undef CYAN
#undef MAGENTA
#undef YELLOW
#undef TRANSPARENT
')
class WindowsApi {
    public static function sendNotification(title:String, message:String):Void {
        untyped __cpp__('
            NOTIFYICONDATAW nid;
            memset(&nid, 0, sizeof(NOTIFYICONDATAW));

            nid.cbSize = sizeof(NOTIFYICONDATAW);
            nid.hWnd = GetActiveWindow();
            nid.uID = 1001;
            
            // NIF_INFO (0x10) + NIF_ICON (0x02)
            nid.uFlags = NIF_INFO | NIF_ICON; 
            
            // NIIF_NONE -> Quita la (i) azul feo
            nid.dwInfoFlags = NIIF_NONE; 

            nid.hIcon = (HICON)GetClassLongPtr(nid.hWnd, GCLP_HICON);

            MultiByteToWideChar(CP_UTF8, 0, {0}.c_str(), -1, nid.szInfoTitle, 64);
            MultiByteToWideChar(CP_UTF8, 0, {1}.c_str(), -1, nid.szInfo, 256);

            Shell_NotifyIconW(NIM_ADD, &nid);
            Shell_NotifyIconW(NIM_MODIFY, &nid);
        ', title, message);
    }

    public static function enable():Void
	{
		#if windows
		setDarkModeCPP();
		#end
	}

	#if windows
	@:functionCode('
		HWND hwnd = GetActiveWindow();
		if (hwnd != NULL)
		{
			BOOL useDarkMode = TRUE;
			// Atributo 20 para Windows 10 (versiones recientes) y Windows 11
			HRESULT hr = DwmSetWindowAttribute(hwnd, 20, &useDarkMode, sizeof(useDarkMode));
			if (FAILED(hr))
			{
				// Atributo 19 para builds antiguas de Windows 10
				DwmSetWindowAttribute(hwnd, 19, &useDarkMode, sizeof(useDarkMode));
			}
		}
	')
	private static function setDarkModeCPP():Void
	{
	}
	#end
}
#end