#include <Windows.h>

//--------------------------------------------------------------------
//
// FUNCTION: wWinMain(HINSTANCE, HINSTANCE, LPWSTR, ULONG)
//
// PURPOSE: Application entry point.
//
//--------------------------------------------------------------------
int WINAPI wWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,
	LPWSTR pCmdLine, int nCmdShow)
{

}

// LOGIN FORM FUNCTION for LoginFunction.h/LoginFunction.cpp
LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)  
{
	switch (msg)
	{
		case WM_COMMAND:
		{
			switch(LOWORD(wParam))
			{
				case IDC_LOGIN_BUTTON:
				{
					// Handle login button being clicked
					break;
				}
			}
			break;
		}
	} 

	return DefWindowProc(hwnd, message, wParam, lParam);
}