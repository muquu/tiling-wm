import XMonad
import XMonad.Config.Desktop
import XMonad.Util.Run (safeSpawn)
import qualified Data.Map as M
import System.Environment (getEnvironment)
import XMonad.Util.EZConfig

mateConfig = desktopConfig
    { terminal = "mate-terminal"
    , keys = mateKeys <+> keys desktopConfig
    }

mateKeys (XConfig {modMask = modm}) = M.fromList $
    [ ((modm, xK_p), mateRun)
    , ((modm .|. shiftMask, xK_q), spawn "mate-session-save --kill") ]

mateRun :: X ()
mateRun = withDisplay $ \dpy -> do
    rw <- asks theRoot
    mate_panel <- getAtom "_MATE_PANEL_ACTION"
    panel_run <- getAtom "_MATE_PANEL_ACTION_RUN_DIALOG"

    io $ allocaXEvent $ \e -> do
        setEventType e clientMessage
        setClientMessageEvent e rw mate_panel 32 panel_run 0
        sendEvent dpy rw False structureNotifyMask e
        sync dpy False

main = do
    xmonad $ mateConfig
                { modMask = mod4Mask
                 , borderWidth = 4
                 , focusedBorderColor = "#7FBC71"
                } `additionalKeysP` myKeys

myKeys = [ (("M4-f"), spawn "firefox")
           ,(("M4-i"), spawn "caja")
           ,(("M4-c"), spawn "chromium --ppapi-flash-path=/usr/lib/PepperFlash/libpepflashplayer.so")
           ,(("M4-z"), kill)
         ]
