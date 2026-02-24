import SwiftUI
import LeetPulseDesignSystemCore

public struct DSTabScaffoldConfig: Sendable {
    public let contentPadding: EdgeInsets
    public let tabBarPadding: EdgeInsets

    public init(
        contentPadding: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0),
        tabBarPadding: EdgeInsets = EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
    ) {
        self.contentPadding = contentPadding
        self.tabBarPadding = tabBarPadding
    }
}

public struct DSTabScaffoldState: Equatable, Sendable {
    public var isEnabled: Bool

    public init(isEnabled: Bool = true) {
        self.isEnabled = isEnabled
    }
}

public struct DSTabScaffoldRenderModel {
    public let background: Color
    public let tabBarBackground: Color
    public let contentPadding: EdgeInsets
    public let tabBarPadding: EdgeInsets
    public let opacity: Double

    public static func make(
        state: DSTabScaffoldState,
        config: DSTabScaffoldConfig,
        theme: DSTheme
    ) -> DSTabScaffoldRenderModel {
        DSTabScaffoldRenderModel(
            background: theme.colors.background,
            tabBarBackground: theme.colors.background,
            contentPadding: config.contentPadding,
            tabBarPadding: config.tabBarPadding,
            opacity: state.isEnabled ? 1.0 : 0.6
        )
    }
}

public struct DSTabScaffold<Content: View>: View {
    private let items: [DSNavItem]
    private let state: DSTabBarState
    private let config: DSTabScaffoldConfig
    private let scaffoldState: DSTabScaffoldState
    private let onSelect: (String) -> Void
    private let content: Content

    @Environment(\.dsTheme) private var theme

    public init(
        items: [DSNavItem],
        state: DSTabBarState,
        config: DSTabScaffoldConfig = DSTabScaffoldConfig(),
        scaffoldState: DSTabScaffoldState = DSTabScaffoldState(),
        onSelect: @escaping (String) -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.items = items
        self.state = state
        self.config = config
        self.scaffoldState = scaffoldState
        self.onSelect = onSelect
        self.content = content()
    }

    public var body: some View {
        let model = DSTabScaffoldRenderModel.make(state: scaffoldState, config: config, theme: theme)

        VStack(spacing: 0) {
            content
                .padding(model.contentPadding)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(model.background)

            DSTabBar(items: items, state: state, onSelect: onSelect)
                .padding(model.tabBarPadding)
                .background(model.tabBarBackground)
        }
        .opacity(model.opacity)
    }
}

public struct DSSidebarScaffoldConfig: Sendable {
    public let sidebarWidth: CGFloat
    public let sidebarPadding: EdgeInsets
    public let contentPadding: EdgeInsets
    public let detailPadding: EdgeInsets
    public let columnSpacing: CGFloat

    public init(
        sidebarWidth: CGFloat = 240,
        sidebarPadding: EdgeInsets = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 8),
        contentPadding: EdgeInsets = EdgeInsets(top: 24, leading: 16, bottom: 24, trailing: 16),
        detailPadding: EdgeInsets = EdgeInsets(top: 24, leading: 16, bottom: 24, trailing: 16),
        columnSpacing: CGFloat = 16
    ) {
        self.sidebarWidth = sidebarWidth
        self.sidebarPadding = sidebarPadding
        self.contentPadding = contentPadding
        self.detailPadding = detailPadding
        self.columnSpacing = columnSpacing
    }
}

public struct DSSidebarScaffoldState: Equatable, Sendable {
    public var isEnabled: Bool

    public init(isEnabled: Bool = true) {
        self.isEnabled = isEnabled
    }
}

public struct DSSidebarScaffoldRenderModel {
    public let background: Color
    public let divider: Color
    public let sidebarWidth: CGFloat
    public let sidebarPadding: EdgeInsets
    public let contentPadding: EdgeInsets
    public let detailPadding: EdgeInsets
    public let columnSpacing: CGFloat
    public let opacity: Double

    public static func make(
        state: DSSidebarScaffoldState,
        config: DSSidebarScaffoldConfig,
        theme: DSTheme
    ) -> DSSidebarScaffoldRenderModel {
        DSSidebarScaffoldRenderModel(
            background: theme.colors.background,
            divider: theme.colors.border,
            sidebarWidth: config.sidebarWidth,
            sidebarPadding: config.sidebarPadding,
            contentPadding: config.contentPadding,
            detailPadding: config.detailPadding,
            columnSpacing: config.columnSpacing,
            opacity: state.isEnabled ? 1.0 : 0.6
        )
    }
}

public struct DSSidebarScaffold<Content: View, Detail: View>: View {
    private let items: [DSNavItem]
    private let state: DSSidebarState
    private let config: DSSidebarScaffoldConfig
    private let scaffoldState: DSSidebarScaffoldState
    private let onSelect: (String) -> Void
    private let content: Content
    private let detail: Detail

    @Environment(\.dsTheme) private var theme

    public init(
        items: [DSNavItem],
        state: DSSidebarState,
        config: DSSidebarScaffoldConfig = DSSidebarScaffoldConfig(),
        scaffoldState: DSSidebarScaffoldState = DSSidebarScaffoldState(),
        onSelect: @escaping (String) -> Void,
        @ViewBuilder content: () -> Content,
        @ViewBuilder detail: () -> Detail
    ) {
        self.items = items
        self.state = state
        self.config = config
        self.scaffoldState = scaffoldState
        self.onSelect = onSelect
        self.content = content()
        self.detail = detail()
    }

    public var body: some View {
        let model = DSSidebarScaffoldRenderModel.make(state: scaffoldState, config: config, theme: theme)

        HStack(spacing: model.columnSpacing) {
            DSSidebar(items: items, state: state, onSelect: onSelect)
                .frame(width: model.sidebarWidth)
                .padding(model.sidebarPadding)

            Divider()
                .background(model.divider)

            content
                .padding(model.contentPadding)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

            detail
                .padding(model.detailPadding)
        }
        .background(model.background)
        .opacity(model.opacity)
    }
}

public extension DSSidebarScaffold where Detail == EmptyView {
    init(
        items: [DSNavItem],
        state: DSSidebarState,
        config: DSSidebarScaffoldConfig = DSSidebarScaffoldConfig(),
        scaffoldState: DSSidebarScaffoldState = DSSidebarScaffoldState(),
        onSelect: @escaping (String) -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            items: items,
            state: state,
            config: config,
            scaffoldState: scaffoldState,
            onSelect: onSelect,
            content: content,
            detail: { EmptyView() }
        )
    }
}
