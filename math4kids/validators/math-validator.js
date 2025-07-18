class MathValidator {
  static validateBasicOperations() {
    console.log('🧮 Validation des opérations de base...');
    
    const tests = [
      { a: 5, b: 3, op: '+', expected: 8 },
      { a: 10, b: 4, op: '-', expected: 6 },
      { a: 7, b: 8, op: '*', expected: 56 },
      { a: 15, b: 3, op: '/', expected: 5 }
    ];
    
    let passed = 0;
    tests.forEach((test, index) => {
      let result;
      switch(test.op) {
        case '+': result = test.a + test.b; break;
        case '-': result = test.a - test.b; break;
        case '*': result = test.a * test.b; break;
        case '/': result = Math.floor(test.a / test.b); break;
      }
      
      if (result === test.expected) {
        console.log(`✅ ${test.a} ${test.op} ${test.b} = ${result}`);
        passed++;
      } else {
        console.log(`❌ ${test.a} ${test.op} ${test.b} = ${result} (attendu: ${test.expected})`);
      }
    });
    
    console.log(`📊 Résultat: ${passed}/${tests.length} tests réussis`);
    return passed === tests.length;
  }
}

if (typeof module !== 'undefined' && module.exports) {
  module.exports = { MathValidator };
  
  if (require.main === module) {
    console.log('🚀 VALIDATION MATHÉMATIQUE MATH4KIDS');
    console.log('====================================');
    
    const isValid = MathValidator.validateBasicOperations();
    
    if (isValid) {
      console.log('🎉 VALIDATION RÉUSSIE !');
      process.exit(0);
    } else {
      console.log('❌ VALIDATION ÉCHOUÉE');
      process.exit(1);
    }
  }
}
