import 'package:flutter/material.dart';
import 'package:ui/routers/go.dart';

class ErrorCode {
  static const String notFound = 'ERRX00001';
  static const String unauthorized = 'ERRX00002';
  static const String forbidden = 'ERRX00003';
  static const String internalServerError = 'ERRX00004';
  static const String badGateway = 'ERRX00005';
  static const String serviceUnavailable = 'ERRX00006';
  static const String gatewayTimeout = 'ERRX00007';
}

class ErrorScreen extends StatelessWidget {
  final String message;
  final int? error; // Código de error opcional

  const ErrorScreen({super.key, required this.message, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icono de error animado
                _buildErrorIcon(context),
                const SizedBox(height: 24),

                // Código de error (si existe)
                if (error != null) _buildErrorCode(context),
                const SizedBox(height: 16),

                // Mensaje de error
                _buildErrorMessage(context),
                const SizedBox(height: 32),

                // Botones de acción
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorIcon(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: isDarkMode
            ? _getColorForError(error).withValues(alpha: 0.2)
            : _getColorForError(error).withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        _getIconForError(error),
        size: 64,
        color: _getColorForError(error),
      ),
    );
  }

  Widget _buildErrorCode(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _getColorForError(error).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getColorForError(error).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        'Error $error',
        style: TextStyle(
          color: _getColorForError(error),
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildErrorMessage(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Text(
          '¡Algo salió mal!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? colorScheme.onSurface : Colors.grey[800],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Código: $message',
          style: TextStyle(
            fontSize: 16,
            color: isDarkMode
                ? colorScheme.onSurface.withValues(alpha: 0.7)
                : Colors.grey[600],
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 12),

        Text(
          'Vuelve a intentarlo en un momento',
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode
                ? colorScheme.onSurface.withValues(alpha: 0.7)
                : Colors.grey[600],
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Botón circular
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? colorScheme.primary.withValues(alpha: 0.2)
                  : colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => Go.back(),
              icon: Icon(
                Icons.arrow_back,
                size: 32,
                color: colorScheme.primary,
              ),
              tooltip: 'Volver',
            ),
          ),
          const SizedBox(height: 8),

          // Texto opcional
          Text(
            'Volver',
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? colorScheme.onSurface : Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Método para obtener el color según el código de error
  Color _getColorForError(int? error) {
    switch (error) {
      case 400:
        // Bad Request
        return Colors.orange;
      case 401:
        // Unauthorized
        return Colors.red;
      case 403:
        // Forbidden
        return Colors.red;
      case 404:
        // Not Found
        return Colors.blue;
      case 500:
        // Internal Server Error
        return Colors.redAccent;
      case 502:
        // Bad Gateway
        return Colors.amber;
      case 503:
        // Service Unavailable
        return Colors.amber;
      case 504:
        // Gateway Timeout
        return Colors.amber;
      default:
        return Colors.red;
    }
  }

  // Método para obtener el icono según el código de error
  IconData _getIconForError(int? error) {
    switch (error) {
      case 400:
        return Icons.warning_amber_rounded;
      case 401:
      case 403:
        return Icons.lock_outline_rounded;
      case 404:
        return Icons.search_off_rounded;
      case 500:
        return Icons.bug_report_outlined;
      case 502:
      case 503:
      case 504:
        return Icons.cloud_off_rounded;
      default:
        return Icons.error_outline_rounded;
    }
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: isDarkMode ? colorScheme.surface : Colors.grey[50],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Loader animado
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Center(child: CircularProgressIndicator()),
              ),
              const SizedBox(height: 32),

              // Texto animado
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                builder: (context, double value, child) {
                  return Opacity(opacity: value, child: child);
                },
                child: Column(
                  children: [
                    Text(
                      'Cargando...',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode
                            ? colorScheme.onSurface
                            : Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Verificando información',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode
                            ? colorScheme.onSurface.withValues(alpha: 0.7)
                            : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
