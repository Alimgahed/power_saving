import 'dart:convert';

/// Encode a scalar at an HTML text or quoted-attribute boundary.
/// Interpolation's existing null representation is deliberately preserved.
String htmlText(Object? value) => const HtmlEscape().convert('$value');
