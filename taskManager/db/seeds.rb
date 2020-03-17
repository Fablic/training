#coding: utf-8
User.create!(
  [
    {
      email:        'kazuyoshi.nagano@rakuten.com',
      first_name:   '千義',
      last_name:    '長野',
      password:     'kazuyoshi123',
      role:         0,
      invalid_flg:  0,
    },
    {
      email:        'ryo.hasebe@rakuten.com',
      first_name:   '亮',
      last_name:    '長谷部',
      password:     'ryo123',
      role:         0,
      invalid_flg:  0,
    },
    {
      email:        'admin@example.com',
      first_name:   '管理者',
      last_name:    'タスクマネージャ',
      password:     'admin123',
      role:         1,
      invalid_flg:  0,
    }
  ]
)
