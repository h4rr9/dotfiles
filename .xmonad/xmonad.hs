-- IMPORTS

import XMonad
import Data.Monoid
import System.Exit
import XMonad.Util.SpawnOnce
import XMonad.Util.Run
import XMonad.Hooks.ManageDocks
import XMonad.Actions.CopyWindow (kill1, killAllOtherCopies)
import XMonad.Actions.WithAll (sinkAll, killAll)
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Layout.Renamed (renamed, Rename(Replace))
import XMonad.Layout.WindowArranger
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), Toggle(..), (??))
import XMonad.Layout.Reflect (REFLECTX(..), REFLECTY(..))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.Spacing
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Tabbed
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.ResizableTile
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ThreeColumns
import XMonad.Actions.MouseResize
import XMonad.Layout.NoBorders
import XMonad.Layout.NoFrillsDecoration
import XMonad.Layout.Decoration
import XMonad.Layout.Simplest
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ServerMode
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers


---------------------------------
--VARIABLES
---------------------------------

myFont ::[Char]
myFont = "xft:Mononoki Nerd Font:style=Regular:pixelsize=13"-- Sets the font

myTerminal :: [Char]
myTerminal = "alacritty"                                    -- Sets default terminal

myBrowser :: [Char]
myBrowser = "google-chrome"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False                                  -- Sts focus to follow mouse

myClickJustFocuses :: Bool
myClickJustFocuses = False                                  -- Uses first click on window to select window

myBorderWidth :: Dimension
myBorderWidth = 3                                           -- Sets border width for windows

myModMask :: KeyMask
myModMask = mod4Mask

myNormalBorderColor :: [Char]
myNormalBorderColor  = "#000000"                            -- Border colour of normal windows

myFocusedBorderColor :: [Char]
myFocusedBorderColor = "#000000"

------------------------------------------------------------------------
--WORKSPACES
------------------------------------------------------------------------

xmobarEscape :: [Char] -> [Char]
xmobarEscape = concatMap doubleLts
    where
        doubleLts '<' = "<<"
        doubleLts x = [x]

myWorkspaces :: [String]
myWorkspaces    = clickable . (map xmobarEscape)
                  $ ["dev","www","sys","doc","vbox","chat","mus","vid","gfx"]
    where
        clickable l = [ "<action=xdotool key super+" ++ show (n) ++ ">" ++ ws ++ "</action>" |
                      (i,ws) <- zip [1..9] l,                                        
                      let n = i ] 

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

------------------------------------------------------------------------
-- KEYBINDINGS
------------------------------------------------------------------------

myKeys :: [([Char], X ())]
myKeys = 
    -- XMonad
    [ ("M-S-r", spawn "xmonad --recompile; xmonad --restart")

    -- Terminal
    , ("M-<Return>", spawn (myTerminal ++ " -e zsh"))

    --demu
    , ("M-p", spawn "dmenu_run")

    --browser
    , ("M-S-<Return>", spawn myBrowser)
    --Window
    , ("M-q", kill1)
    , ("M-S-q", killAll)
    , ("M-m", windows W.focusMaster)
    , ("M-j", windows W.focusDown)
    , ("M-k", windows W.focusUp)
    , ("M-S-m", windows W.swapMaster)
    , ("M-S-j", windows W.swapDown)
    , ("M-S-k", windows W.swapUp)

    
    --Floating windows
    , ("M-<Delete>", withFocused $ windows . W.sink) -- Push floating window back to tile
    , ("M-S-<Delete>", sinkAll) 


   --Layouts 
    , ("M-<Tab>", sendMessage NextLayout)                                    -- Switch to next layout
    , ("M-<Space>", sendMessage (Toggle NBFULL) >> sendMessage ToggleStruts) -- Toggles noborder/full
    , ("M-S-<Space>", sendMessage ToggleStruts)                              -- Toggles struts
    , ("M-S-n", sendMessage $ Toggle NOBORDERS)                              -- Toggles noborder
    , ("M-S-x", sendMessage $ Toggle REFLECTX)
    , ("M-S-y", sendMessage $ Toggle REFLECTY)
    , ("M-<KP_Multiply>", sendMessage (IncMasterN 1))   -- Increase number of clients in master pane
    , ("M-<KP_Divide>", sendMessage (IncMasterN (-1)))  -- Decrease number of clients in master pane






    , ("<XF86AudioLowerVolume>", spawn "amixer set Master 5%- unmute")
    , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 5%+ unmute")
    , ("<XF86AudioMute>", spawn "amixer sset Master toggle")
    , ("<XF86AudioPlay>", spawn "/usr/bin/python3 -m spotifycli --playpause") 
    , ("<XF86AudioPrev>", spawn "/usr/bin/python3 -m spotifycli --prev")
    , ("<XF86AudioNext>", spawn "/usr/bin/python3 -m spotifycli --next")



    ] 


----------------------------------------------------------------------
 --Mouse bindings: default actions bound to mouse events
----------------------------------------------------------------------

myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                        >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                        >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- LAYOUTS
------------------------------------------------------------------------
-- Makes setting the spacingRaw simpler to write. The spacingRaw
-- module adds a configurable amount of space around windows.
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

topBarTheme = def
    { fontName              = myFont
    , inactiveBorderColor   = "#002b36"
    , inactiveColor         = "#002b36"
    , inactiveTextColor     = "#002b36"
    , activeBorderColor     = "#268bd2"
    , activeColor           = "#268bd2"
    , activeTextColor       = "#268bd2"
    , urgentBorderColor     = "#dc322f"
    , urgentTextColor       = "#c58900"
    , decoHeight            = 10
    }


myTabConfig = def { fontName            = myFont
                    , activeColor         = "#268bd2"
                    , inactiveColor       = "#073642"
                    , activeBorderColor   = "#268bd2"
                    , inactiveBorderColor = "#073642"
                    , activeTextColor     = "#002b36"
                    , inactiveTextColor   = "#657b83"
                    }

tall     = renamed [Replace "tall"]
           $ noFrillsDeco shrinkText topBarTheme
           $ limitWindows 12
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
grid     = renamed [Replace "grid"]
           $ noFrillsDeco shrinkText topBarTheme
           $ limitWindows 12
           $ mySpacing 8
           $ mkToggle (single MIRROR)
           $ Grid (16/10)
threeCol = renamed [Replace "threeCol"]
           $ noFrillsDeco shrinkText topBarTheme
           $ limitWindows 7
           $ mySpacing' 4
           $ ThreeCol 1 (3/100) (1/2)
tabs     = renamed [Replace "tabs"]
           -- I cannot add spacing to this layout because it will
           -- add spacing between window and tabs which looks bad.
           $ addTabs shrinkText myTabConfig
           $ Simplest

myLayoutHook = avoidStruts $ mouseResize $ windowArrange $ 
               mkToggle (NBFULL ?? NOBORDERS ?? EOT) $ myDefaultLayout
             where
               myDefaultLayout = tall ||| grid ||| noBorders tabs |||  threeCol 

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore 
    ]

-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook :: X ()
myStartupHook = do
    spawnOnce "nitrogen --restore &"


------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main :: IO ()
main = do
    xmproc <- spawnPipe "xmobar /home/h4rr9/.config/xmobar/xmobarrc"
    xmonad $ ewmh def
        {
        -- simple stuff
            terminal           = myTerminal,
            focusFollowsMouse  = myFocusFollowsMouse,
            clickJustFocuses   = myClickJustFocuses,
            borderWidth        = myBorderWidth,
            modMask            = myModMask,
            workspaces         = myWorkspaces,
            normalBorderColor  = myNormalBorderColor,
            focusedBorderColor = myFocusedBorderColor,

        -- key bindings
            -- keys               = myKeys,
            mouseBindings      = myMouseBindings,

        -- hooks, layouts
            layoutHook         = myLayoutHook,
            manageHook         = ( isFullscreen --> doFullFloat ) <+> myManageHook <+> manageDocks,
            handleEventHook    = serverModeEventHookCmd 
                               <+> serverModeEventHook 
                               <+> serverModeEventHookF "XMONAD_PRINT" (io . putStrLn)
                               <+> docksEventHook

,
            logHook            = dynamicLogWithPP xmobarPP
                        { ppOutput = \x -> hPutStrLn xmproc x
                        , ppCurrent = xmobarColor "#c3e88d" "" . wrap "[" "]" -- Current workspace in xmobar
                        , ppVisible = xmobarColor "#c3e88d" ""                -- Visible but not current workspace
                        , ppHidden = xmobarColor "#82AAFF" "" . wrap "*" ""   -- Hidden workspaces in xmobar
                        , ppHiddenNoWindows = xmobarColor "#F07178" ""        -- Hidden workspaces (no windows)
                        , ppTitle = xmobarColor "#d0d0d0" "" . shorten 60     -- Title of active window in xmobar
                        , ppSep =  "<fc=#666666> | </fc>"                     -- Separators in xmobar
                        , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"  -- Urgent workspace
                        , ppExtras  = [windowCount]                           -- # of windows current workspace
                        , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                        }
,
            startupHook        = myStartupHook
        } `additionalKeysP` myKeys

