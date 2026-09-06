# Aarogya research-data training

Training stays outside the Flutter app.

```
C:\Users\japme\AppData\Local\Programs\Python\Python310\python.exe -m pip install -r ml/requirements.txt
C:\Users\japme\AppData\Local\Programs\Python\Python310\python.exe -m ml.train_physio_context
```

- Non-EEG ATR labels train `physio-context-v1`.
- Empatica E4 is processed only. Session folders are protocol context, not emergency labels.
- Fall detection is trained separately with `ml/train_fall_detector.py` on SisFall when the archive is available. If training cannot run, the app keeps `fall-seq-v1`.
