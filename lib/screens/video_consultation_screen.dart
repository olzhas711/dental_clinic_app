import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VideoConsultationScreen extends StatefulWidget {
  final String patientName;

  const VideoConsultationScreen({
    Key? key, 
    required this.patientName,
  }) : super(key: key);

  @override
  _VideoConsultationScreenState createState() => _VideoConsultationScreenState();
}

class _VideoConsultationScreenState extends State<VideoConsultationScreen> {
  bool _isCameraOn = false;
  bool _isMicrophoneOn = false;
  bool _isRecording = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Видеоконсультация с ${widget.patientName}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              child: Center(
                child: _isCameraOn 
                    ? const Text(
                        'Видео пациента', 
                        style: TextStyle(color: Colors.white)
                      )
                    : const Icon(
                        Icons.videocam_off, 
                        color: Colors.white, 
                        size: 100
                      ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(_isCameraOn ? Icons.videocam : Icons.videocam_off),
                  onPressed: () {
                    setState(() {
                      _isCameraOn = !_isCameraOn;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(_isMicrophoneOn ? Icons.mic : Icons.mic_off),
                  onPressed: () {
                    setState(() {
                      _isMicrophoneOn = !_isMicrophoneOn;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(_isRecording 
                      ? Icons.stop_circle 
                      : Icons.record_voice_over
                  ),
                  onPressed: () {
                    setState(() {
                      _isRecording = !_isRecording;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_isRecording 
                            ? 'Запись начата' 
                            : 'Запись остановлена'
                        ),
                      ),
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    _showEndConsultationDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Завершить'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEndConsultationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Завершение консультации'),
        content: const Text(
          'Вы уверены, что хотите завершить видеоконсультацию? '
          'Будет составлен протокол консультации.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
              _showConsultationReportDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Завершить'),
          ),
        ],
      ),
    );
  }

  void _showConsultationReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Протокол консультации'),
        content: SingleChildScrollView(
          child: Text(
            'Пациент: ${widget.patientName}\n'
            'Дата: 28.01.2024\n'
            'Врач: Иванов И.И.\n'
            'Диагноз: Кариес зуба 16\n'
            'Рекомендации: Плановая санация, профилактическая чистка'
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Сохранение протокола
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Протокол сохранен'),
                ),
              );
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}
