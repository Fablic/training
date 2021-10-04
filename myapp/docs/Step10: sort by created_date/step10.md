# ステップ10

## タスク一覧を作成日時の順番で並び替えましょう ★ スキップ可能

- 現在IDの順で並んでいますが、これを作成日時の降順で並び替えてみましょう
- 並び替えがうまく行っていることをsystem specで書いてみましょう

## work log

```rb
  def index
    @tasks = Task.where(deleted: 0).order(created_at: :desc)
  end
```

### 作成日時の項順にtaskを並び替え

`tasks_controller.rb`
created_atの項順(desc)でsortするように変更
```rb
  def index
    @tasks = Task.where(deleted: 0).order(created_at: :desc)
  end
```

### sortに関するspec作成
すべての項目に順番がつくようにfactoryを修正
```rb
FactoryBot.define do
    factory :task, class: Task do
        sequence(:title) { |n| "test_title#{n}" }
        sequence(:description) { |n| "test_description#{n}" }
        sequence(:created_at) { |n| "2021-10-04 00:00:.00000#{n}"}
    end
end
```

作成順に
```rb
    it 'sort by created_at desc' do
      expect(find('tr:nth-child(2)')).to have_content task_list[0].title
      expect(find('tr:nth-child(3)')).to have_content task_list[1].title
      expect(find('tr:nth-child(4)')).to have_content task_list[2].title
      expect(find('tr:nth-child(5)')).to have_content task_list[3].title
    end
```

## 学び
### :nth-child()が便利
n番目に表示される要素を指定して、findと組み合わせて取得することができる
