import XMonad
    ( mod4Mask, gets, io, spawn, (|||), xmonad, (-->), (<+>), (=?), className
    , composeAll, doFloat, doShift, title, sendMessage, windows, withFocused
    ,  KeyMask, Dimension, Default(def), Query, WindowSet, X
    ,  XConfig( manageHook, layoutHook, logHook, startupHook
              , focusFollowsMouse, terminal, modMask, borderWidth
              , normalBorderColor, focusedBorderColor, workspaces)
    , XState(windowset), ChangeLayout(NextLayout), Full(Full), Tall(Tall)
    )

import XMonad.Hooks.DynamicLog
    ( dynamicLogWithPP, shorten, wrap, xmobarColor, xmobarPP
    , PP( ppOutput, ppCurrent, ppVisible, ppHidden, ppHiddenNoWindows
        , ppTitle, ppSep, ppUrgent, ppExtras, ppOrder
        )
    )
import XMonad.Hooks.ManageDocks (avoidStruts, docks, manageDocks)
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat)
import XMonad.Hooks.WorkspaceHistory (workspaceHistoryHook)
import XMonad.Hooks.SetWMName (setWMName)
import XMonad.Hooks.EwmhDesktops (ewmh)

import XMonad.Util.Run (spawnPipe)
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.SpawnOnce (spawnOnce)

import XMonad.Layout.NoBorders (noBorders, smartBorders)
import XMonad.Layout.Grid (Grid(..))
import XMonad.Layout.Spacing (spacingRaw, Border(Border), Spacing)
import XMonad.Layout.LayoutModifier (ModifiedLayout)

import XMonad.Actions.WithAll (killAll)
import XMonad.Actions.CopyWindow (kill1)

import qualified XMonad.StackSet as XM_SS (integrate', stack, workspace, current, sink)

import Data.Monoid (Endo)

import System.IO (hPutStrLn)
import System.Exit (exitSuccess)

main :: IO ()
main = do
    xmproc0 <- spawnPipe "xmobar -x 0 $HOME/.config/xmobar/xmobarrc0"
    xmproc1 <- spawnPipe "xmobar -x 1 $HOME/.config/xmobar/xmobarrc1"

    xmonad $ ewmh $ docks $ def
        { manageHook = (isFullscreen --> doFullFloat)
                <+> manageDocks
                <+> myManageHook
        , layoutHook = myLayoutHook
        , logHook = workspaceHistoryHook
            <+> dynamicLogWithPP xmobarPP
            { ppOutput = \x -> hPutStrLn xmproc0 x >> hPutStrLn xmproc1 x
            , ppCurrent = xmobarColor "#98971a" "" . wrap "[" "]"
            , ppVisible = xmobarColor "#98971a" ""
            , ppHidden = xmobarColor "#458588" ""
            , ppHiddenNoWindows = xmobarColor "#d3869b" ""
            , ppTitle = xmobarColor "#b16286" "" . shorten 43
            , ppSep =  "<fc=#a89984> | </fc>"
            , ppUrgent = xmobarColor "#cc241d" "" . wrap "!" "!"
            , ppExtras  = [windowCount]
            , ppOrder  = \(ws:l:t:_) -> [ws,l] ++ [t]
            }
        , startupHook = myStartupHook
        , focusFollowsMouse = False
        , terminal = myTerm
        , modMask = myMod
        , borderWidth = myBorderW
        , normalBorderColor = myNormalColor
        , focusedBorderColor = myFocusColor
        , workspaces = myWorkspaces
        }
        `additionalKeysP` myKeys

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . XM_SS.integrate' . XM_SS.stack . XM_SS.workspace . XM_SS.current . windowset

myTerm :: String
myTerm = "termite"

myMod :: KeyMask
myMod = mod4Mask

myBorderW :: Dimension
myBorderW = 2

myFocusColor :: String
myFocusColor = "#a89984"

myNormalColor :: String
myNormalColor = "#3c3836"

myWorkspaces :: [String]
myWorkspaces = ["www", "dev", "sys", "gfx", "vbox", "chat"]

myManageHook :: Query (Endo WindowSet)
myManageHook = composeAll
    [ className =? "Brave-browser" --> doShift (head myWorkspaces)
    , className =? "Gimp-2.10" --> doShift (myWorkspaces !! 3)
    , className =? "org.inkscape.Inkscape" --> doShift (myWorkspaces !! 3)
    , className =? "discord" --> doShift (myWorkspaces !! 5)
    , className =? "VirtualBox" --> doFloat
    , className =? "VirtualBox Manager" --> doShift (myWorkspaces !! 4)
    , title =? "FLOATING" --> doFloat
    ]

myLayoutHook =
        avoidStruts (noBorders Full)
    ||| smartBorders (avoidStruts $ mySpacing 2 $ Tall 1 (5/100) (1/2))
    ||| smartBorders (avoidStruts $ mySpacing 2 Grid)

mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

myStartupHook :: X ()
myStartupHook = do
    spawnOnce "trayer --edge top --align right --widthtype request --padding 0 --SetDockType true --SetPartialStrut true --expand true --monitor 0 --margin 0 --iconspacing 5 --transparent true --alpha 0 --tint 0x1d2021 --height 22 &"
    setWMName "LG3D"

myKeys :: [([Char], X ())]
myKeys =
    [ ("M-C-r", spawn "xmonad --recompile && xmonad --restart")
    , ("M-C-q", io exitSuccess)

    , ("M-<Return>", spawn myTerm)
    , ("M-<Space>", spawn "rofi -show drun")
    , ("M-s", spawn "flameshot gui")

    , ("M-S-w", kill1)
    , ("M-S-x", killAll)
    , ("M-S-t", withFocused $ windows . XM_SS.sink)

    , ("M-<Tab>", sendMessage NextLayout)

    , ("<XF86AudioLowerVolume>", spawn "amixer sset 'Master' 5%- unmute")
    , ("<XF86AudioRaiseVolume>", spawn "amixer sset 'Master' 5%+ unmute")
    , ("<XF86AudioMute>", spawn "amixer sset 'Master' toggle")
    , ("<XF86MonBrightnessUp>", spawn "brightnessctl set +5%")
    , ("<XF86MonBrightnessDown>", spawn "brightnessctl set 5%-")
    ]
