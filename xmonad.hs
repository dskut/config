import XMonad
import XMonad.Actions.WindowGo
import XMonad.Actions.Volume
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Grid
import XMonad.Layout.Tabbed
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Util.Run(spawnPipe, runInTerm)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

main = xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig

myBar = "/usr/bin/xmobar"

myPP = xmobarPP { ppCurrent = xmobarColor "#429942" "" . wrap "<" ">" }

toggleStrutsKey XConfig { XMonad.modMask = modMask } = (modMask, xK_b)

myLayout = noBorders simpleTabbed ||| Grid ||| noBorders Full ||| tall ||| Mirror tall
    where
        tall = Tall nmaster delta ratio
        nmaster = 1
        delta = 0.03
        ratio = 0.5

fullLayout = noBorders Full
termLayout = Grid

myConfig = defaultConfig
    { terminal = "xterm"
    , modMask = mod4Mask
    , borderWidth = 2
    , workspaces = ["1:dev", "2:term", "3:web", "4:doc", "5", "6", "7:music", "8:mail", "9:im", "0", "-", "="]
    , manageHook = myManageHook <+> manageHook defaultConfig
    , layoutHook = onWorkspaces ["3:web", "4:doc", "7:music", "8:mail", "9:im"] fullLayout
                 $ onWorkspace "2:term" termLayout
                 $ myLayout
    , startupHook = myStartup
    } `additionalKeys`
    [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
    , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
    , ((0, xK_Print), spawn "scrot")
    , ((mod4Mask, xK_w), spawn "conkeror")
    , ((mod4Mask, xK_t), spawn "xterm")
    , ((mod4Mask, xK_e), spawn "evince")
    , ((mod4Mask, xK_f), raiseMaybe (runInTerm "-title finch" "finch") (title =? "finch"))
    , ((mod4Mask, xK_m), raiseMaybe (runInTerm "-title mutt" "mutt") (title =? "mutt"))
    -- XF86AudioMute
    , ((0, 0x1008ff12), toggleMute >> return ())
    -- XF86AudioLowerVolume
    , ((0, 0x1008ff11), lowerVolume 2 >> return ())
    -- XF86AudioRaiseVolume
    , ((0, 0x1008ff13), raiseVolume 2 >> return ())
    -- XF86MonBrightnessDown
    , ((0, 0x1008ff03), spawn "set-brightness.sh -1")
    -- XF86MonBrightnessUp
    , ((0, 0x1008ff02), spawn "set-brightness.sh +1")
    ]

myManageHook = composeAll
    [ className =? "Pidgin" --> doShift "9:im"
    , title =? "finch" --> doShift "9:im"
    , title =? "mutt" --> doShift "8:mail"
    , title =? "ncmpcpp" --> doShift "7:music"
    , className =? "Evince" --> doShift "4:doc"
    , className =? "Conkeror" --> doShift "3:web"
    , manageDocks
    ]

myStartup :: X ()
myStartup = do
            raiseMaybe (runInTerm "-title finch" "finch") (title =? "finch")
            raiseMaybe (runInTerm "-title mutt" "mutt") (title =? "mutt")
            raiseMaybe (runInTerm "-title ncmpcpp" "ncmpcpp") (title =? "ncmpcpp")
            spawn "conkeror"
