# Change Log

## 0.5.2 (2016-10-24)
- Switched timestamps from DateTime to Time for simpler usage with gRPC int32. Nowadays [Time has most capabilities of Datetime anyway](http://stackoverflow.com/questions/1261329/whats-the-difference-between-datetime-and-time-in-ruby#answer-1261435)

## 0.5.1 (2016-10-19)
- Added coercion to Datastore types (on save)

## 0.5.0.1 (2016-10-19)
- Fixed rubygems date

## 0.5.0 (2016-10-18)
- Added gem Coercible for static type coercion

## 0.4.2 (2016-10-18)
- Added 'require time' to Timestamps module
