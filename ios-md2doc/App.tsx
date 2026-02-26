import React, { useState, useEffect } from 'react';
import {
  StyleSheet,
  View,
  Text,
  TextInput,
  TouchableOpacity,
  ScrollView,
  Modal,
  Dimensions,
  KeyboardAvoidingView,
  Platform,
  SafeAreaView,
  StatusBar,
  Animated,
} from 'react-native';
import { StatusBar as ExpoStatusBar } from 'expo-status-bar';
import { GestureHandlerRootView } from 'react-native-gesture-handler';
import {
  FileTextIcon,
  SettingsIcon,
  ChevronDownIcon,
  MoreHorizontalIcon,
  TypeIcon,
  LayersIcon,
  PlusIcon,
  CheckIcon,
  ArrowUpRightIcon,
  FileImageIcon,
  ShieldCheckIcon,
  PlayIcon,
} from './src/utils/icons';
import { normalize, spacing, fontSize, borderRadius, layout, isIPad } from './src/utils/responsive';

const { width: SCREEN_WIDTH, height: SCREEN_HEIGHT } = Dimensions.get('window');

type ExportFormat = 'DOCX' | 'PDF' | 'IMAGE';
type Status = 'idle' | 'processing' | 'success';

interface WatermarkConfig {
  enabled: boolean;
  text: string;
  opacity: number;
}

interface Config {
  fontSize: number;
  theme: string;
  numbering: boolean;
  watermark: WatermarkConfig;
}

const DEFAULT_CONTENT = `# 移动端适配进展

1. 支持 DOCX/PDF/图片 导出
2. 增加全局水印配置
3. 优化转换交互逻辑

\`\`\`mermaid
graph LR
MD --> DOCX
MD --> PDF
MD --> IMAGE
\`\`\``;

export default function App() {
  const [isEditMode, setIsEditMode] = useState(true);
  const [showSheet, setShowSheet] = useState(false);
  const [status, setStatus] = useState<Status>('idle');
  const [exportFormat, setExportFormat] = useState<ExportFormat>('DOCX');
  const [content, setContent] = useState(DEFAULT_CONTENT);
  const [fadeAnim] = useState(new Animated.Value(0));
  const [slideAnim] = useState(new Animated.Value(100));
  
  const [config, setConfig] = useState<Config>({
    fontSize: 14,
    theme: 'Standard',
    numbering: true,
    watermark: {
      enabled: false,
      text: 'Md2Doc Internal',
      opacity: 0.2,
    },
  });

  useEffect(() => {
    if (showSheet) {
      Animated.parallel([
        Animated.timing(fadeAnim, {
          toValue: 1,
          duration: 300,
          useNativeDriver: true,
        }),
        Animated.spring(slideAnim, {
          toValue: 0,
          tension: 50,
          friction: 10,
          useNativeDriver: true,
        }),
      ]).start();
    } else {
      fadeAnim.setValue(0);
      slideAnim.setValue(100);
    }
  }, [showSheet]);

  const handleConvert = () => {
    setStatus('processing');
    setTimeout(() => {
      setStatus('success');
      setTimeout(() => setStatus('idle'), 3000);
    }, 1800);
  };

  const renderWatermark = () => {
    if (!config.watermark.enabled || isEditMode) return null;
    
    const watermarkElements = [];
    const cols = isIPad ? 6 : 4;
    const rows = isIPad ? 10 : 8;
    
    for (let i = 0; i < cols * rows; i++) {
      watermarkElements.push(
        <Text key={i} style={[styles.watermarkText, { opacity: config.watermark.opacity }]}>
          {config.watermark.text}
        </Text>
      );
    }
    
    return (
      <View style={styles.watermarkContainer} pointerEvents="none">
        {watermarkElements}
      </View>
    );
  };

  const renderPreview = () => (
    <Animated.View style={[styles.previewContainer, { opacity: fadeAnim }]}>
      <Text style={styles.previewTitle}>移动端适配进展</Text>
      <View style={styles.previewList}>
        <Text style={styles.previewItem}>• 支持 <Text style={styles.previewBold}>DOCX/PDF/图片</Text> 导出</Text>
        <Text style={styles.previewItem}>• 增加全局水印配置</Text>
        <Text style={styles.previewItem}>• 优化转换交互逻辑</Text>
      </View>
      <View style={styles.mermaidPlaceholder}>
        <PlayIcon size={48} color="#D1D5DB" strokeWidth={1} />
        <Text style={styles.mermaidLabel}>Mermaid Engine</Text>
      </View>
    </Animated.View>
  );

  const renderEditor = () => (
    <TextInput
      style={[styles.textInput, { fontSize: normalize(config.fontSize) }]}
      placeholder="开始书写你的灵感..."
      placeholderTextColor="#E5E7EB"
      value={content}
      onChangeText={setContent}
      multiline
      textAlignVertical="top"
    />
  );

  const renderFormatSelector = () => {
    if (status !== 'idle') return null;
    
    return (
      <View style={styles.formatSelector}>
        {(['DOCX', 'PDF', 'IMAGE'] as ExportFormat[]).map((fmt) => (
          <TouchableOpacity
            key={fmt}
            onPress={() => setExportFormat(fmt)}
            style={[
              styles.formatButton,
              exportFormat === fmt && styles.formatButtonActive,
            ]}
          >
            <Text style={[styles.formatText, exportFormat === fmt && styles.formatTextActive]}>
              {fmt}
            </Text>
          </TouchableOpacity>
        ))}
      </View>
    );
  };

  const renderExportButton = () => {
    const getButtonStyle = () => {
      switch (status) {
        case 'processing':
          return [styles.exportButton, styles.exportButtonProcessing];
        case 'success':
          return [styles.exportButton, styles.exportButtonSuccess];
        default:
          return [styles.exportButton, styles.exportButtonIdle];
      }
    };

    const renderContent = () => {
      switch (status) {
        case 'processing':
          return <View style={styles.spinner} />;
        case 'success':
          return (
            <View style={styles.successContent}>
              <CheckIcon size={20} color="#FFFFFF" strokeWidth={4} />
              <Text style={styles.exportButtonText}>Saved to Files</Text>
            </View>
          );
        default:
          return (
            <View style={styles.idleContent}>
              <Text style={styles.exportButtonText}>Export {exportFormat}</Text>
              {exportFormat === 'DOCX' ? (
                <FileTextIcon size={20} color="#FFFFFF" />
              ) : exportFormat === 'PDF' ? (
                <ArrowUpRightIcon size={20} color="#FFFFFF" />
              ) : (
                <FileImageIcon size={20} color="#FFFFFF" />
              )}
            </View>
          );
      }
    };

    return (
      <TouchableOpacity
        onPress={handleConvert}
        style={getButtonStyle()}
        activeOpacity={0.9}
      >
        {renderContent()}
      </TouchableOpacity>
    );
  };

  const renderSettingsSheet = () => (
    <Modal
      visible={showSheet}
      transparent
      animationType="slide"
      onRequestClose={() => setShowSheet(false)}
    >
      <View style={styles.sheetOverlay}>
        <TouchableOpacity
          style={styles.sheetBackdrop}
          activeOpacity={1}
          onPress={() => setShowSheet(false)}
        />
        <Animated.View
          style={[
            styles.sheetContent,
            {
              transform: [{ translateY: slideAnim }],
            },
          ]}
        >
          <View style={styles.sheetHandle} />
          
          <View style={styles.sheetSection}>
            <View style={styles.sheetCard}>
              <Text style={styles.sheetSectionTitle}>Typography</Text>
              <View style={styles.sheetRow}>
                <Text style={styles.sheetLabel}>正文字号</Text>
                <View style={styles.sheetValueRow}>
                  <Text style={styles.sheetValue}>{config.fontSize}</Text>
                  <View style={styles.sliderContainer}>
                    {[12, 13, 14, 15, 16, 17, 18].map((size) => (
                      <TouchableOpacity
                        key={size}
                        onPress={() => setConfig({ ...config, fontSize: size })}
                        style={[
                          styles.sliderDot,
                          config.fontSize === size && styles.sliderDotActive,
                        ]}
                      />
                    ))}
                  </View>
                </View>
              </View>
            </View>

            <View style={styles.sheetCard}>
              <View style={styles.sheetRow}>
                <View style={styles.sheetLabelRow}>
                  <ShieldCheckIcon size={20} color="#3B82F6" />
                  <Text style={styles.sheetSectionTitle}>Watermark</Text>
                </View>
                <TouchableOpacity
                  onPress={() =>
                    setConfig({
                      ...config,
                      watermark: {
                        ...config.watermark,
                        enabled: !config.watermark.enabled,
                      },
                    })
                  }
                  style={[
                    styles.toggle,
                    config.watermark.enabled && styles.toggleActive,
                  ]}
                >
                  <View
                    style={[
                      styles.toggleKnob,
                      config.watermark.enabled && styles.toggleKnobActive,
                    ]}
                  />
                </TouchableOpacity>
              </View>

              {config.watermark.enabled && (
                <View style={styles.watermarkSettings}>
                  <View style={styles.inputGroup}>
                    <Text style={styles.inputLabel}>内容</Text>
                    <TextInput
                      style={styles.textInputSmall}
                      value={config.watermark.text}
                      onChangeText={(text) =>
                        setConfig({
                          ...config,
                          watermark: { ...config.watermark, text },
                        })
                      }
                      placeholder="输入水印文字..."
                    />
                  </View>
                  <View style={styles.inputGroup}>
                    <Text style={styles.inputLabel}>透明度</Text>
                    <View style={styles.opacitySlider}>
                      {[0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5].map((op) => (
                        <TouchableOpacity
                          key={op}
                          onPress={() =>
                            setConfig({
                              ...config,
                              watermark: { ...config.watermark, opacity: op },
                            })
                          }
                          style={[
                            styles.opacityDot,
                            config.watermark.opacity === op && styles.opacityDotActive,
                          ]}
                        />
                      ))}
                    </View>
                  </View>
                </View>
              )}
            </View>

            <TouchableOpacity
              style={styles.applyButton}
              onPress={() => setShowSheet(false)}
            >
              <Text style={styles.applyButtonText}>Apply Settings</Text>
            </TouchableOpacity>
          </View>
        </Animated.View>
      </View>
    </Modal>
  );

  return (
    <GestureHandlerRootView style={styles.container}>
      <ExpoStatusBar style="dark" />
      <SafeAreaView style={styles.safeArea}>
        <View style={styles.header}>
          <TouchableOpacity style={styles.headerLeft}>
            <View style={styles.logo}>
              <FileTextIcon size={18} color="#FFFFFF" />
            </View>
            <View style={styles.headerTitle}>
              <Text style={styles.headerSubtitle}>Md2Doc</Text>
              <View style={styles.headerTitleRow}>
                <Text style={styles.headerTitleText}>产品需求文档</Text>
                <ChevronDownIcon size={14} color="#D1D5DB" />
              </View>
            </View>
          </TouchableOpacity>

          <View style={styles.headerRight}>
            <TouchableOpacity
              onPress={() => setIsEditMode(!isEditMode)}
              style={[styles.modeButton, !isEditMode && styles.modeButtonActive]}
            >
              <Text style={[styles.modeButtonText, !isEditMode && styles.modeButtonTextActive]}>
                {isEditMode ? 'Preview' : 'Edit'}
              </Text>
            </TouchableOpacity>
            <TouchableOpacity style={styles.moreButton}>
              <MoreHorizontalIcon size={22} color="#9CA3AF" />
            </TouchableOpacity>
          </View>
        </View>

        <View style={styles.main}>
          <View style={styles.card}>
            {renderWatermark()}
            <ScrollView
              style={styles.scrollView}
              contentContainerStyle={styles.scrollContent}
              showsVerticalScrollIndicator={false}
            >
              {isEditMode ? renderEditor() : renderPreview()}
            </ScrollView>

            {isEditMode && (
              <View style={styles.toolbar}>
                <View style={styles.toolbarLeft}>
                  <TouchableOpacity style={styles.toolbarButton}>
                    <TypeIcon size={20} color="#D1D5DB" />
                  </TouchableOpacity>
                  <TouchableOpacity style={styles.toolbarButton}>
                    <LayersIcon size={20} color="#D1D5DB" />
                  </TouchableOpacity>
                  <TouchableOpacity style={styles.toolbarButton}>
                    <PlusIcon size={20} color="#D1D5DB" />
                  </TouchableOpacity>
                </View>
                <TouchableOpacity
                  style={styles.settingsButton}
                  onPress={() => setShowSheet(true)}
                >
                  <Text style={styles.settingsButtonText}>Settings</Text>
                  <SettingsIcon size={16} color="#9CA3AF" />
                </TouchableOpacity>
              </View>
            )}
          </View>
        </View>

        <View style={styles.bottomContainer}>
          {renderFormatSelector()}
          {renderExportButton()}
        </View>

        {renderSettingsSheet()}
      </SafeAreaView>
    </GestureHandlerRootView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F8F9FB',
  },
  safeArea: {
    flex: 1,
  },
  header: {
    paddingTop: isIPad ? spacing.xl : spacing.lg,
    paddingBottom: spacing.md,
    paddingHorizontal: layout.contentPadding,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    backgroundColor: 'rgba(255, 255, 255, 0.4)',
  },
  headerLeft: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.sm,
  },
  logo: {
    width: normalize(32),
    height: normalize(32),
    borderRadius: borderRadius.sm,
    backgroundColor: '#000000',
    alignItems: 'center',
    justifyContent: 'center',
  },
  headerTitle: {
    marginLeft: spacing.xs,
  },
  headerSubtitle: {
    fontSize: fontSize.xs,
    color: '#9CA3AF',
    fontWeight: '700',
    letterSpacing: 1.5,
    textTransform: 'uppercase',
  },
  headerTitleRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.xs,
  },
  headerTitleText: {
    fontSize: fontSize.md,
    fontWeight: '700',
  },
  headerRight: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.sm,
  },
  modeButton: {
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.xs + 2,
    borderRadius: borderRadius.full,
    backgroundColor: '#F3F4F6',
  },
  modeButtonActive: {
    backgroundColor: '#2563EB',
  },
  modeButtonText: {
    fontSize: fontSize.xs,
    fontWeight: '700',
    textTransform: 'uppercase',
    letterSpacing: 0.5,
    color: '#6B7280',
  },
  modeButtonTextActive: {
    color: '#FFFFFF',
  },
  moreButton: {
    padding: spacing.xs,
  },
  main: {
    flex: 1,
    paddingHorizontal: layout.contentPadding,
    paddingBottom: spacing.md,
  },
  card: {
    flex: 1,
    backgroundColor: '#FFFFFF',
    borderRadius: borderRadius.xxl,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 8 },
    shadowOpacity: 0.03,
    shadowRadius: 40,
    borderWidth: 1,
    borderColor: '#F3F4F6',
    overflow: 'hidden',
  },
  watermarkContainer: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'center',
    alignItems: 'center',
    transform: [{ rotate: '-30deg' }],
    zIndex: 10,
  },
  watermarkText: {
    fontSize: fontSize.lg,
    fontWeight: '700',
    color: '#9CA3AF',
    marginHorizontal: spacing.xl,
    marginVertical: spacing.lg,
  },
  scrollView: {
    flex: 1,
  },
  scrollContent: {
    padding: isIPad ? spacing.xxl : spacing.lg,
  },
  textInput: {
    flex: 1,
    lineHeight: normalize(28),
    fontWeight: '500',
    color: '#1D1D1F',
    minHeight: SCREEN_HEIGHT * 0.5,
  },
  previewContainer: {
    gap: spacing.lg,
  },
  previewTitle: {
    fontSize: isIPad ? fontSize.xxxl : fontSize.xxl,
    fontWeight: '800',
    letterSpacing: -0.5,
  },
  previewList: {
    gap: spacing.md,
  },
  previewItem: {
    fontSize: fontSize.md,
    color: '#4B5563',
    lineHeight: normalize(28),
    fontWeight: '500',
  },
  previewBold: {
    fontWeight: '700',
    color: '#1D1D1F',
  },
  mermaidPlaceholder: {
    marginTop: spacing.xxl,
    padding: isIPad ? spacing.xxl * 2 : spacing.xxl,
    backgroundColor: '#F9FAFB',
    borderRadius: borderRadius.xl,
    borderWidth: 2,
    borderStyle: 'dashed',
    borderColor: '#E5E7EB',
    alignItems: 'center',
    gap: spacing.md,
  },
  mermaidLabel: {
    fontSize: fontSize.xs,
    fontWeight: '700',
    textTransform: 'uppercase',
    letterSpacing: 1.5,
    color: '#9CA3AF',
  },
  toolbar: {
    height: normalize(64),
    borderTopWidth: 1,
    borderTopColor: '#F9FAFB',
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: isIPad ? spacing.xl : spacing.lg,
    backgroundColor: 'rgba(255, 255, 255, 0.8)',
  },
  toolbarLeft: {
    flexDirection: 'row',
    gap: isIPad ? spacing.xl : spacing.lg,
  },
  toolbarButton: {
    padding: spacing.xs,
  },
  settingsButton: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.xs,
  },
  settingsButtonText: {
    fontSize: fontSize.xs,
    fontWeight: '800',
    textTransform: 'uppercase',
    letterSpacing: 1.5,
    color: '#9CA3AF',
  },
  bottomContainer: {
    position: 'absolute',
    bottom: isIPad ? spacing.xxl : spacing.lg,
    left: 0,
    right: 0,
    alignItems: 'center',
    gap: spacing.md,
    zIndex: 30,
  },
  formatSelector: {
    flexDirection: 'row',
    backgroundColor: 'rgba(0, 0, 0, 0.05)',
    padding: spacing.xs,
    borderRadius: borderRadius.full,
    gap: spacing.xs,
  },
  formatButton: {
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.xs + 2,
    borderRadius: borderRadius.full,
  },
  formatButtonActive: {
    backgroundColor: '#FFFFFF',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.05,
    shadowRadius: 2,
  },
  formatText: {
    fontSize: fontSize.xs,
    fontWeight: '800',
    color: '#9CA3AF',
  },
  formatTextActive: {
    color: '#000000',
  },
  exportButton: {
    height: layout.bottomButtonHeight,
    borderRadius: borderRadius.full,
    alignItems: 'center',
    justifyContent: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 20 },
    shadowOpacity: 0.15,
    shadowRadius: 50,
  },
  exportButtonIdle: {
    backgroundColor: '#000000',
    width: isIPad ? normalize(240) : normalize(224),
    paddingHorizontal: spacing.lg,
  },
  exportButtonProcessing: {
    backgroundColor: '#000000',
    width: layout.bottomButtonHeight,
  },
  exportButtonSuccess: {
    backgroundColor: '#34C759',
    width: isIPad ? normalize(280) : normalize(224),
    paddingHorizontal: spacing.lg,
  },
  idleContent: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    width: '100%',
  },
  successContent: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.sm,
  },
  exportButtonText: {
    color: '#FFFFFF',
    fontSize: fontSize.sm,
    fontWeight: '800',
    textTransform: 'uppercase',
    letterSpacing: -0.5,
  },
  spinner: {
    width: normalize(24),
    height: normalize(24),
    borderRadius: normalize(12),
    borderWidth: 2,
    borderColor: 'rgba(255, 255, 255, 0.2)',
    borderTopColor: '#FFFFFF',
  },
  sheetOverlay: {
    flex: 1,
    justifyContent: 'flex-end',
  },
  sheetBackdrop: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: 'rgba(0, 0, 0, 0.4)',
  },
  sheetContent: {
    backgroundColor: '#F2F2F7',
    borderTopLeftRadius: borderRadius.xxl + normalize(16),
    borderTopRightRadius: borderRadius.xxl + normalize(16),
    padding: isIPad ? spacing.xxl : spacing.lg,
    paddingBottom: isIPad ? spacing.xxl * 2 : spacing.xxl,
    maxHeight: SCREEN_HEIGHT * 0.9,
  },
  sheetHandle: {
    width: normalize(64),
    height: normalize(6),
    backgroundColor: '#E5E7EB',
    borderRadius: normalize(3),
    alignSelf: 'center',
    marginBottom: spacing.lg,
  },
  sheetSection: {
    gap: spacing.md,
  },
  sheetCard: {
    backgroundColor: '#FFFFFF',
    borderRadius: borderRadius.xxl,
    padding: isIPad ? spacing.xl : spacing.lg,
    gap: spacing.md,
  },
  sheetSectionTitle: {
    fontSize: fontSize.xs,
    fontWeight: '800',
    color: '#9CA3AF',
    textTransform: 'uppercase',
    letterSpacing: 2,
  },
  sheetRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  sheetLabel: {
    fontSize: fontSize.md,
    fontWeight: '700',
  },
  sheetLabelRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.sm,
  },
  sheetValueRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.lg,
  },
  sheetValue: {
    fontSize: fontSize.xxl,
    fontWeight: '800',
  },
  sliderContainer: {
    flexDirection: 'row',
    gap: spacing.sm,
  },
  sliderDot: {
    width: normalize(12),
    height: normalize(12),
    borderRadius: normalize(6),
    backgroundColor: '#E5E7EB',
  },
  sliderDotActive: {
    backgroundColor: '#000000',
  },
  toggle: {
    width: normalize(48),
    height: normalize(28),
    borderRadius: normalize(14),
    backgroundColor: '#E5E7EB',
    padding: spacing.xs,
  },
  toggleActive: {
    backgroundColor: '#34C759',
  },
  toggleKnob: {
    width: normalize(20),
    height: normalize(20),
    borderRadius: normalize(10),
    backgroundColor: '#FFFFFF',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.1,
    shadowRadius: 2,
  },
  toggleKnobActive: {
    transform: [{ translateX: normalize(20) }],
  },
  watermarkSettings: {
    gap: spacing.md,
    paddingTop: spacing.md,
    borderTopWidth: 1,
    borderTopColor: '#F9FAFB',
  },
  inputGroup: {
    gap: spacing.xs,
  },
  inputLabel: {
    fontSize: fontSize.xs,
    fontWeight: '700',
    color: '#9CA3AF',
  },
  textInputSmall: {
    backgroundColor: '#F9FAFB',
    padding: spacing.md,
    borderRadius: borderRadius.lg,
    fontSize: fontSize.md,
    fontWeight: '700',
  },
  opacitySlider: {
    flexDirection: 'row',
    gap: spacing.xs,
  },
  opacityDot: {
    width: normalize(16),
    height: normalize(16),
    borderRadius: normalize(8),
    backgroundColor: '#E5E7EB',
  },
  opacityDotActive: {
    backgroundColor: '#000000',
  },
  applyButton: {
    backgroundColor: '#000000',
    paddingVertical: spacing.lg,
    borderRadius: borderRadius.xl,
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 10 },
    shadowOpacity: 0.2,
    shadowRadius: 20,
  },
  applyButtonText: {
    color: '#FFFFFF',
    fontSize: fontSize.lg,
    fontWeight: '800',
  },
});
