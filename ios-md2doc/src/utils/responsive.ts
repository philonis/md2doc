import { Dimensions, Platform, PixelRatio } from 'react-native';

const { width: SCREEN_WIDTH, height: SCREEN_HEIGHT } = Dimensions.get('window');

export const isIPad = Platform.isPad || (Platform.OS === 'ios' && SCREEN_WIDTH >= 768);

export const isLandscape = SCREEN_WIDTH > SCREEN_HEIGHT;

const BASE_WIDTH = isIPad ? 768 : 375;

const scale = SCREEN_WIDTH / BASE_WIDTH;

export function normalize(size: number): number {
  const newSize = size * scale;
  if (Platform.OS === 'ios') {
    return Math.round(PixelRatio.roundToNearestPixel(newSize));
  }
  return Math.round(newSize);
}

export function wp(percentage: number): number {
  const value = (percentage * SCREEN_WIDTH) / 100;
  return Math.round(value);
}

export function hp(percentage: number): number {
  const value = (percentage * SCREEN_HEIGHT) / 100;
  return Math.round(value);
}

export const spacing = {
  xs: normalize(4),
  sm: normalize(8),
  md: normalize(16),
  lg: normalize(24),
  xl: normalize(32),
  xxl: normalize(48),
};

export const fontSize = {
  xs: normalize(10),
  sm: normalize(12),
  md: normalize(14),
  lg: normalize(16),
  xl: normalize(18),
  xxl: normalize(24),
  xxxl: normalize(32),
};

export const borderRadius = {
  sm: normalize(8),
  md: normalize(16),
  lg: normalize(24),
  xl: normalize(32),
  xxl: normalize(40),
  full: normalize(999),
};

export const layout = {
  screenWidth: SCREEN_WIDTH,
  screenHeight: SCREEN_HEIGHT,
  isIPad,
  isLandscape,
  contentPadding: isIPad ? spacing.xl : spacing.md,
  headerHeight: isIPad ? normalize(100) : normalize(88),
  bottomButtonHeight: isIPad ? normalize(72) : normalize(64),
  cardWidth: isIPad ? SCREEN_WIDTH * 0.6 : SCREEN_WIDTH - spacing.md * 2,
  maxContentWidth: isIPad ? 840 : SCREEN_WIDTH,
};

export default {
  normalize,
  wp,
  hp,
  spacing,
  fontSize,
  borderRadius,
  layout,
  isIPad,
  isLandscape,
};
