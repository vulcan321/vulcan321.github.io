
```cpp
void CheckMouseButtonStatus()
{
   //Check the mouse left button is pressed or not
   if ((GetKeyState(VK_LBUTTON) & 0x80) != 0)
   {
      AfxMessageBox(_T("LButton pressed"));
   }
   //Check the mouse right button is pressed or not
   if ((GetKeyState(VK_RBUTTON) & 0x80) != 0)
   {
      AfxMessageBox(_T("RButton pressed"));
   }
}
```