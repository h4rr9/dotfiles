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

---------------------------------
--VARIABLES
---------------------------------

myFont ::[Char]
myFont = "xft:Fira Code:style=Regular:pixelsize=11"         -- Sets the font

myTerminal :: [Char]
myTerminal = "alacritty"                                    -- Sets default terminal

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False                                  -- Sts focus to follow mouse

myClickJustFocuses :: Bool
myClickJustFocuses = False                                  -- Uses first click on window to select window

myBorderWidth :: Dimension
myBorderWidth = 3                                           -- Sets border width for windows

myModMask :: KeyMask
myModMask = mod4Mask

myWorkspaces :: [String]
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

myNormalBorderColor :: [Char]
myNormalBorderColor  = "#292d3e"                            -- Border colour of normal windows

myFocusedBorderColor :: [Char]
myFocusedBorderColor = "#98971a"

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
    , ("<XF86AudioPlay>", spawn "python3 -m spotifycli --playpause") 
    , ("<XF86AudioPrev>", spawn "python3 -m spotifycli --prev")
    , ("<XF86AudioNext>", spawn "python3 -m spotifycli --next")



    ] 

--myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    ---- launch a terminal
    --[ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    ---- launch dmenu
    --, ((modm,               xK_p     ), spawn "dmenu_run")

    ---- launch gmrun
    --, ((modm .|. shiftMask, xK_p     ), spawn "gmrun")

    ---- close focused window
    --, ((modm .|. shiftMask, xK_c     ), kill)

     ---- Rotate through the available layout algorithms
    --, ((modm,               xK_space ), sendMessage NextLayout)

    ----  Reset the layouts on the current workspace to default
    --, ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    ---- Resize viewed windows to the correct size
    --, ((modm,               xK_n     ), refresh)

    ---- Move focus to the next window
    --, ((modm,               xK_Tab   ), windows W.focusDown)

    ---- Move focus to the next window
    --, ((modm,               xK_j     ), windows W.focusDown)

    ---- Move focus to the previous window
    --, ((modm,               xK_k     ), windows W.focusUp  )

    ---- Move focus to the master window
    --, ((modm,               xK_m     ), windows W.focusMaster  )

    ---- Swap the focused window and the master window
    --, ((modm,               xK_Return), windows W.swapMaster)

    ---- Swap the focused window with the next window
    --, ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    ---- Swap the focused window with the previous window
    --, ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    ---- Shrink the master area
    --, ((modm,               xK_h     ), sendMessage Shrink)

    ---- Expand the master area
    --, ((modm,               xK_l     ), sendMessage Expand)

    ---- Push window back into tiling
    --, ((modm,               xK_t     ), withFocused $ windows . W.sink)

    ---- Increment the number of windows in the master area
    --, ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    ---- Deincrement the number of windows in the master area
    --, ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    ---- Toggle the status bar gap
    ---- Use this binding with avoidStruts from Hooks.ManageDocks.
    ---- See also the statusBar function from Hooks.DynamicLog.
    ----
    ---- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    ---- Quit xmonad
    --, ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    ---- Restart xmonad
    --, ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    ---- Run xmessage with a summary of the default keybindings (useful for beginners)
    --, ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
    --]
     -- ++

    ----
    ---- mod-[1..9], Switch to workspace N
    ---- mod-shift-[1..9], Move client to workspace N
    ----
    --[((m .|. modm, k), windows $ f i)
         -- | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        --, (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
     -- ++

    ----
    ---- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    ---- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    ----
    --[((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
         -- | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        --, (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


----------------------------------------------------------------------
 --Mouse bindings: default actions bound to mouse events

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

tall     = renamed [Replace "tall"]
           $ limitWindows 12
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
grid     = renamed [Replace "grid"]
           $ limitWindows 12
           $ mySpacing 8
           $ mkToggle (single MIRROR)
           $ Grid (16/10)
threeCol = renamed [Replace "threeCol"]
           $ limitWindows 7
           $ mySpacing' 4
           $ ThreeCol 1 (3/100) (1/2)
tabs     = renamed [Replace "tabs"]
           -- I cannot add spacing to this layout because it will
           -- add spacing between window and tabs which looks bad.
           $ tabbed shrinkText myTabConfig
  where
    myTabConfig = def { fontName            = "xft:Mononoki Nerd Font:regular:pixelsize=11"
                      , activeColor         = "#292d3e"
                      , inactiveColor       = "#3e445e"
                      , activeBorderColor   = "#292d3e"
                      , inactiveBorderColor = "#292d3e"
                      , activeTextColor     = "#ffffff"
                      , inactiveTextColor   = "#d0d0d0"
                      }
          
-- The layout hook
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
------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = return ()

------------------------------------------------------------------------
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
    xmonad $ docks def
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
            manageHook         = myManageHook,
            handleEventHook    = myEventHook,
            logHook            = myLogHook,
            startupHook        = myStartupHook
        } `additionalKeysP` myKeys

