import SwiftUI

struct Player {
    let nickname: String
    let score: Int
}

struct Question: Hashable{
    let emoticon: String
    let category: String
    let question: String
    let answer: String
    var isOnFocus: Bool
}

struct ValidAnswerChar: Hashable{
    var valid: Bool
    var alphabet: String
}

struct ContentView: View {
    var body: some View {
        HelloWord()
    }
}

struct HelloWord: View {
    
    @State var leaderboard: [Player] = []
    
    var body: some View {
        Home()
    }
}

struct Home: View {
    @State var listOfQuestions: [Question] = [
        Question(emoticon: "🍔", category: "Food", question: "A small, juicy fruit, with smooth skin that is either green, red, or purple", answer: "grape", isOnFocus: false),
        Question(emoticon: "🍔", category: "Food", question: "Slice of bread with or other food between them such as meat, cheese", answer: "sandwich", isOnFocus: false),
        Question(emoticon: "🍔", category: "Food", question: "The liquid from fruits is used for drinking", answer: "juice", isOnFocus: false),
        Question(emoticon: "🍔", category: "Food", question: "A candy or syrup made of ground cacao with added sugar", answer: "chocolate", isOnFocus: false),
        Question(emoticon: "🍔", category: "Food", question: "A food made by baking a dough of flour or meal", answer: "bread", isOnFocus: false),
        Question(emoticon: "🍔", category: "Food", question: "The first meal of the day", answer: "breakfast", isOnFocus: false),
        
        Question(emoticon: "🐱", category: "Animals", question: "A mamal with a very long neck, long legs", answer: "giraffe", isOnFocus: false),
        Question(emoticon: "🐱", category: "Animals", question: "A small animal that flies  at night", answer: "bat", isOnFocus: false),
        Question(emoticon: "🐱", category: "Animals", question: "A large australian animal with a strong tail and back legs, that moves by jumping", answer: "kangaroo", isOnFocus: false),
        Question(emoticon: "🐱", category: "Animals", question: "A large, powerful animal of the cat family that hunts in groups", answer: "lion", isOnFocus: false),
        Question(emoticon: "🐱", category: "Animals", question: "A tropcal bird with brightly colored feathers", answer: "parrot", isOnFocus: false),
        Question(emoticon: "🐱", category: "Animals", question: "A large sea fish with very sharp theeth and a ponted fin on it's back", answer: "shark", isOnFocus: false),
        
        Question(emoticon: "🏰", category: "Places", question: "An area of land, along with buildings and equipment, used to grow crops or raise animals for food or clothing", answer: "farm", isOnFocus: false),
        Question(emoticon: "🏰", category: "Places", question: "A place where books, records, and other materials are kept and from which they may be borrowed", answer: "library", isOnFocus: false),
        Question(emoticon: "🏰", category: "Places", question: "A place where goods are sold", answer: "market", isOnFocus: false),
        Question(emoticon: "🏰", category: "Places", question: "An informal restaurant, coffe shop that usually specializes in simple meals, coffees, and desserts", answer: "cafe", isOnFocus: false),
        
        Question(emoticon: "🏫", category: "School", question: "A Formal test to determine how much a person knows", answer: "exam", isOnFocus: false),
        Question(emoticon: "🏫", category: "School", question: "A piece of furniture with drawers and a flat suraface used for reading and writing", answer: "desk", isOnFocus: false),
        Question(emoticon: "🏫", category: "School", question: "Schoolwork that is to be done at home rather than at school", answer: "homework", isOnFocus: false),
        Question(emoticon: "🏫", category: "School", question: "A long, thin tool use for writing or drawing", answer: "pencil", isOnFocus: false),
        
        
    ].shuffled()
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("wellcome-screen")
                    .ignoresSafeArea(.all)
                
                VStack(spacing: 30) {
                    NavigationLink(destination: Game(questions: $listOfQuestions ), label: {
                        Text("Play now ")
                            .bold()
                            .frame(width: 300, height: 100)
                            .background(Color("CustomPrimary"))
                            .foregroundColor(.white)
                            .cornerRadius(50)
                            .font(.system(size: 40))
                            .padding(.top, 300)
                    })
                    
                    NavigationLink(destination: Overview(), label: {
                        Text("Overview")
                            .bold()
                            .frame(width: 300, height: 100)
                            .background(Color("CustomWarning"))
                            .foregroundColor(.white)
                            .cornerRadius(50)
                            .font(.system(size: 40))
                    })
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct Overview: View {
    var body: some View {
        ZStack {
            Image("overview")
                .ignoresSafeArea(.all)

            VStack(alignment: .leading) {
                Text("HELLO WORD")
                    .font(.system(size: 80))
                    .bold()
                    .padding(.bottom, 20)
                
                Text("Hello Word is a fun vocabulary game for young learners and young teens with a level of basic user. In this game, students read a definition of a word and have to guess what the word is using the letters that appear. This game is a great way to practice reading, spelling and reviewing vocabulary all at the same time.")
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 35))
                    .padding(.bottom, 10)

                
                Text("In this game, students have to read the definition and guess what the word is. There are 4 categories of vocabulary (food, animal, places, school), every time we make a mistake in arranging words, our lives will decrease and our score will decrease if lives have reached 0 then the game is over.")
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 35))
            }
            .padding(.top, 50)
            .padding(.horizontal, 100)
        }
        .foregroundColor(.white)
    }
}

struct Game: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @Binding var questions: [Question]
    @State var currentQuest: Question
    
    @State var currentUserAnswer: Array<String?> = []
    @State var flattenCurrentUserAnswer: String = ""
    @State var currentAnswer: String = ""
    
    @State var showGameOverSheet: Bool = false
    @State var score: Int = 0
    @State var lives: Int = 3
    @State var numberOfWrong: Int = 0
    @State var numberOfClickedAnswer: Int = 0
    @State var numberOfQuest: Int = 0
    
    @State var isGameOver: Bool = false
    @State var isCorrect: Bool = false
    
    let columns = [
        GridItem(.adaptive(minimum: 100), alignment: .leading)
    ]
    
    init(questions: Binding<[Question]>){
        
        self._questions = questions

        let initialCurrentQuest: Question = questions.wrappedValue[0]
        self._currentQuest = State(initialValue: initialCurrentQuest)
        
        self._currentUserAnswer = State(initialValue: Array(repeating: nil, count: questions.wrappedValue[0].answer.count))

    }
        
    var body: some View {
        ZStack {
            Color("CustomPrimaryBackground").ignoresSafeArea(.all)
            
            VStack(alignment: .center) {
                
                // Level
                ScrollView(.horizontal){
                    HStack(spacing: 20) {
                        ForEach(questions, id: \.self){ question in
                            VStack (spacing: 5) {
                                Text("\(question.emoticon)")
                                    .font(.system(size: 40))
                                                        
                                Text(question.category)
                                    .font(.system(size: 30))
                                    .bold()
                            }
                            .padding()
                            .frame(width: 200, height: 120, alignment: .center)
                            .background(question.isOnFocus ? Color("CustomWarning") : Color("CustomSecondaryBackground"))
                            .cornerRadius(10)
                            
                        }
                    }
                }
                .padding(.horizontal, 50)
                .padding(.bottom, 50)
                
                // Question
                VStack {
                    Text(currentQuest.question)
                        .font(.system(size: 50))
                        .italic()
                        .bold()
                        .multilineTextAlignment(.center)
                }
                .frame(height: 150)
                .padding(.horizontal, 50)
                .padding(.bottom, 50)
                
                // Lives
                VStack {
                    HStack (spacing: 20) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.red)
                        
                        Text("\(lives)")
                            .font(.system(size: 50))
                    }
                }
                .padding(.bottom, 10)
                
                // Score
                VStack {
                    Text("Score: \(score)")
                        .font(.title)
                }
                .padding(.bottom, 50)
                
                // Answer word block
                VStack (alignment: .center){
                    HStack(spacing: 20) {
                        ForEach(currentUserAnswer, id: \.self){element in
                            if(element == nil){
                                Text("")
                                    .bold()
                                    .font(.system(size: 50))
                                    .frame(width: 80, height: 80)
                                    .padding(1)
                                    .background(Color("CustomSecondaryBackground"))
                                    .cornerRadius(10)
                            } else {
                                Text(String(element!).uppercased())
                                    .bold()
                                    .font(.system(size: 50))
                                    .frame(width: 80, height: 80)
                                    .padding(1)
                                    .background(
                                        currentQuest.answer.count == numberOfClickedAnswer
                                        ? flattenCurrentUserAnswer == currentQuest.answer
                                            ? Color("CustomPrimary")
                                            : Color("CustomDanger")
                                        : Color("CustomSecondaryBackground")
                                    )
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding(.bottom, 50)
                .frame(width: 500, height: 100, alignment: .center)
                
                // Shuffle word answer
                VStack(alignment: .center){
                    HStack (spacing: 10){
                        ForEach(Array(currentQuest.answer).shuffled(), id: \.self){ char in
                            Text(String(char).uppercased())
                                .font(.system(size: 50))
                                .bold()
                                .frame(width: 100, height: 100)
                                .background(.bar)
                                .cornerRadius(10)
                                .onTapGesture {
                                    clickAnswerChar(alphabet: String(char))
                                }
                        }
                    }
                }
                .sheet(isPresented: $isGameOver, content: {
                    VStack {
                        NavigationView {
                            VStack {
                                Text("🎉")
                                    .font(.system(size: 100))
                                    .padding(.bottom)

                                Text("Your Score")
                                    .font(.system(size: 60))
                                    .padding(.bottom)

                                Text("\(score) Point")
                                    .font(.system(size: 50))
                                    .bold()
                                
                                Button(action: {
                                    isGameOver = false
                                    
                                    mode.wrappedValue.dismiss()
                                }){
                                    Text("Back to home")
                                        .bold()
                                        .frame(width: 300, height: 100)
                                        .background(Color("CustomPrimary"))
                                        .foregroundColor(.white)
                                        .cornerRadius(50)
                                        .font(.system(size: 30))
                                }
                            }
                            .navigationTitle("Game Over")
                            .navigationBarTitleDisplayMode(.inline)
                        }
                        .foregroundColor(.black)
                    }
                })
            }
            .foregroundColor(.white)
            
        }
        .navigationBarTitle(Text(""), displayMode: .inline)
    }
    
    func resetUserAnswer() -> Void {
        
        numberOfClickedAnswer = 0
        flattenCurrentUserAnswer = ""
        currentUserAnswer = Array(repeating: nil, count: questions[numberOfQuest].answer.count)
        
    }
    
    func nextQuest() -> Void {
        
        if(numberOfQuest >= questions.count){
            gameOver()
        } else {
                        
            if(numberOfQuest > 0){
                questions[numberOfQuest - 1].isOnFocus = false
            }
            
            questions[numberOfQuest].isOnFocus = true
            
            currentQuest = questions[numberOfQuest]
            resetUserAnswer()
        }
        
    }
    
    func gameOver() -> Void {
        print("game over called")
        isGameOver = true
    }
    
    func clickAnswerChar(alphabet: String) -> Void{
        
        currentUserAnswer.insert(alphabet, at: 0 + numberOfClickedAnswer)
        currentUserAnswer.removeLast()
        flattenCurrentUserAnswer += alphabet

        numberOfClickedAnswer += 1
        
        if(flattenCurrentUserAnswer == currentQuest.answer){
            
            isCorrect = true
            
            if(numberOfClickedAnswer == currentQuest.answer.count){
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    
                    numberOfQuest += 1
                    
                    score += 10
                    
                    nextQuest()
                }
            }
            
        } else {
            isCorrect = false
            
            if(numberOfClickedAnswer == currentQuest.answer.count){
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    resetUserAnswer()
                    
                    lives -= 1
                    if(lives <= 0){
                        gameOver()
                        lives = 0
                    }
                
                    if(score == 0){
                        score = 0
                    } else {
                        score -= 2
                    }
                
                }
            }
        }
        
    }
    
    func checkCurrentAnswer() -> Void {
        currentQuest.isOnFocus = true
    }
    
}
