import XMonad
import XMonad.Actions.WindowGo
import XMonad.Actions.Volume
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Grid
import XMonad.Layout.Tabbed
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Run(spawnPipe, runInTerm)
import XMonad.Util.Themes
import System.IO

import qualified XMonad.StackSet as W

main = xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig

myBar = "/usr/bin/xmobar"

myPP = xmobarPP { ppCurrent = xmobarColor "#429942" "" . wrap "<" ">" }

toggleStrutsKey XConfig { XMonad.modMask = modMask } = (modMask, xK_b)

myConfig = defaultConfig
    { terminal = "xterm"
    , modMask = modm
    , borderWidth = 2
    , workspaces = myWorkspaces
    , manageHook = myManageHook <+> manageHook defaultConfig
    , layoutHook = myLayoutHook
    , startupHook = myStartup
    } `additionalKeys` myKeys

modm = mod4Mask

myTabConfig = (theme kavonLakeTheme) 
                { fontName = "xft:Bitstream Vera:size=8"
                , inactiveColor = "#000000"
                }

myLayout = tabbed shrinkText myTabConfig ||| Grid ||| Full ||| tall ||| Mirror tall
    where
        tall = Tall nmaster delta ratio
        nmaster = 1
        delta = 0.03
        ratio = 0.5

myWorkspaces = ["1:dev", "2:web", "3:term", "4", "5", "6", "7", "8", "9", "0:mail", "-:im", "=:music"]

--myLayoutHook = onWorkspaces ["0:mail", "-:im", "=:music"] Full $ myLayout
myLayoutHook = myLayout

myKeys = 
    [ ((modm .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
    , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
    , ((0, xK_Print), spawn "scrot")
    , ((modm .|. controlMask, xK_w), spawn "conkeror")
    , ((modm .|. controlMask, xK_e), spawn "emacs")
    , ((modm .|. controlMask, xK_m), raiseMaybe (runInTerm "-title mutt" "mutt") (title =? "mutt"))
    , ((modm, xK_p), spawn "dmenu_run -fn 'xft:Bitstream Vera:size=10' -b")
    --, ((modm, xK_t), spawn "xterm")
    --, ((modm, xK_e), spawn "evince")
    --, ((modm, xK_f), raiseMaybe (runInTerm "-title finch" "finch") (title =? "finch"))
    -- rebind some keys cause defaults are stupid
    , ((modm, xK_j), windows W.focusUp)
    , ((modm, xK_k), windows W.focusDown)
    , ((modm .|. shiftMask, xK_j), windows W.swapUp)
    , ((modm .|. shiftMask, xK_k), windows W.swapDown)
    -- XF86AudioMute
    , ((0, 0x1008ff12), toggleMute >> return ())
    -- XF86AudioLowerVolume
    , ((0, 0x1008ff11), lowerVolume 2 >> return ())
    -- XF86AudioRaiseVolume
    , ((0, 0x1008ff13), raiseVolume 2 >> return ())
    -- XF86MonBrightnessDown
    , ((0, 0x1008ff03), spawn "xbacklight -10 -time 0 -steps 1")
    -- XF86MonBrightnessUp
    , ((0, 0x1008ff02), spawn "xbacklight +10 -time 0 -steps 1")
    ]
    -- my bindings to workspaces
    ++
    [((m .|. modm, k), windows $ f i)
       | (i, k) <- zip myWorkspaces [xK_1, xK_2, xK_3, xK_4, xK_5, xK_6, xK_7, xK_8, xK_9, xK_0, xK_minus, xK_equal]
       , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    -- VERY specific bindings to my monitors at work
    ++
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_e, xK_w, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

myManageHook = composeAll
    [ className =? "Pidgin" --> doShift "-:im"
    , title =? "finch" --> doShift "-:im"
    --, title =? "mutt" --> doShift "0:mail"
    , title =? "ncmpcpp" --> doShift "=:music"
    --, className =? "Evince" --> doShift "4:doc"
    --, className =? "Conkeror" --> doShift "3:web"
    , manageDocks
    ]

myStartup :: X ()
myStartup = do
            raiseMaybe (runInTerm "-title ncmpcpp" "ncmpcpp") (title =? "ncmpcpp")
            --raiseMaybe (runInTerm "-title finch" "finch") (title =? "finch")
            --raiseMaybe (runInTerm "-title mutt" "mutt") (title =? "mutt")
            --spawn "conkeror"
