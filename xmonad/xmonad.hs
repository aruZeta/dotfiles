-- .: ~ xmonad/xmonad.hs file ~ :.
-- by aru

import XMonad
    ( mod4Mask, io, spawn, (|||), xmonad, (-->), (<+>), (=?), className
    , composeAll, doFloat, doShift, title, sendMessage, windows, withFocused
    ,  KeyMask, Dimension, Default(def), Query, WindowSet, X
    ,  XConfig( manageHook, layoutHook, startupHook
              , focusFollowsMouse, terminal, modMask, borderWidth
              , normalBorderColor, focusedBorderColor, workspaces)
    , ChangeLayout(NextLayout), Full(Full), Tall(Tall)
    )

import XMonad.Hooks.ManageDocks (avoidStruts, docks, manageDocks)
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat)
import XMonad.Hooks.SetWMName (setWMName)
import XMonad.Hooks.EwmhDesktops (ewmh)

import XMonad.Util.EZConfig (additionalKeysP)

import XMonad.Layout.Grid (Grid(..))
import XMonad.Layout.Spacing (spacingRaw, Border(Border), Spacing)
import XMonad.Layout.LayoutModifier (ModifiedLayout)

import XMonad.Actions.WithAll (killAll)
import XMonad.Actions.CopyWindow (kill1)

import qualified XMonad.StackSet as XM_SS

import XMonad.Util.SpawnOnce (spawnOnce)

import Data.Monoid (Endo)

import System.Exit (exitSuccess)

main :: IO ()
main = do
    xmonad $ ewmh $ docks $ def
        { manageHook = (isFullscreen --> doFullFloat)
                <+> manageDocks
                <+> myManageHook
        , layoutHook = myLayoutHook
        , startupHook = myStartupHook
        , focusFollowsMouse = True
        , terminal = myTerm
        , modMask = myMod
        , borderWidth = myBorderW
        , normalBorderColor = myNormalColor
        , focusedBorderColor = myFocusColor
        , workspaces = myWorkspaces
        }
        `additionalKeysP` myKeys

myTerm :: String
myTerm = "alacritty"

myMod :: KeyMask
myMod = mod4Mask

myBorderW :: Dimension
myBorderW = 5

myFocusColor :: String
myFocusColor = "#504945"

myNormalColor :: String
myNormalColor = "#1d2021"

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
        avoidStruts (mySpacing 5 Full)
    ||| avoidStruts (mySpacing 5 $ Tall 1 (5/100) (1/2))
    ||| avoidStruts (mySpacing 5 Grid)

mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) False (Border i i i i) True

myStartupHook :: X ()
myStartupHook = do
    setWMName "LG3D"
    spawnOnce "eww daemon"

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
