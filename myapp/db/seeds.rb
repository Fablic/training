User.create!(
    name: 'ラクマ太郎',
    email: 'rakuma@rakuten.com',
    password: 'password',
    deleted: false,
)

Label.create!(
    [
        label: 'Label_A'
        color: '#ffffff'
        bgcolor: '#19902d'
    ],
    [
        label: 'Label_B'
        color: '#ffffff'
        bgcolor: '#19902d'
    ],
)
