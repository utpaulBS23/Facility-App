// Author: Md. Shahin Bashar
// Created: 2026-04-06

part of 'rules.dart';

class ServiceNamingConvention extends DartLintRule {
  // WHY: configs accepted for API symmetry with other rules; no configurable options yet.
  const ServiceNamingConvention(CustomLintConfigs configs) : super(code: _code);

  static const _code = LintCode(
    name: 'invalid_service_name',
    problemMessage: 'Names in a service file must include "Service".',
    correctionMessage: 'Try renaming to include "Service"',
    errorSeverity: ErrorSeverity.ERROR,
  );

  bool _isInServiceFile(CustomLintResolver resolver) {
    return resolver.source.fullName.contains('di/parts/services.dart');
  }

  void _checkNameAndReport({
    required String name,
    required AstNode node,
    required ErrorReporter reporter,
  }) {
    if (!name.contains('Service')) {
      reporter.atNode(node, _code);
    }
  }

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addVariableDeclaration((node) {
      if (!_isInServiceFile(resolver)) return;
      _checkNameAndReport(
        name: node.name.lexeme,
        node: node,
        reporter: reporter,
      );
    });

    context.registry.addMethodDeclaration((node) {
      if (!_isInServiceFile(resolver)) return;
      _checkNameAndReport(
        name: node.name.lexeme,
        node: node,
        reporter: reporter,
      );
    });

    context.registry.addFunctionDeclaration((node) {
      if (!_isInServiceFile(resolver)) return;
      _checkNameAndReport(
        name: node.name.lexeme,
        node: node,
        reporter: reporter,
      );
    });
  }
}
