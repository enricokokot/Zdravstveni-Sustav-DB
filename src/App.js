// import logo from './logo.svg';
import NavBar from './components/navbar';
import Counters from './components/counters';
import './App.css';
import React, { Component } from 'react';

class App extends Component {
  state = { 
    counters : [
        { id: 1, value: 4},
        { id: 2, value: 0},
        { id: 3, value: 0},
        { id: 4, value: 0},
    ]
  };

  constructor() {
    super();
    console.log('App - Constructor');
  };

  componentDidMount() {
    console.log('App - Mounted');
  }

  handleIncrement = counter => {
      const counters = [...this.state.counters];
      // in the og we find the element with same values
      const index = counters.indexOf(counter);
      // const index = counter.id - 1;
      // why is the line below necessary if it already contains the
      // current state of counters? it works well without
      // counters[index] = { ...counter };
      counters[index].value++;
      this.setState( { counters } );
  };

  handleReset = () => {
      const counters = this.state.counters.map(c => {
          c.value = 0;
          return c;
      });
      this.setState({ counters });
  };
  // is counterId the key and that's why we don't need to specify?!
  handleDelete = (counterId) => { 
      // console.log("Event Handler Called", counterId);
      const counters = this.state.counters.filter( c => c.id !== counterId);
      this.setState({ counters });
  };

  render() {
    console.log('App - Rendered')

    return (
      <React.Fragment>
        <NavBar totalCounters={this.state.counters.filter( c => c.value > 0).length}/>
        <main className="container">
          <Counters
            counters={this.state.counters}
            onReset={this.handleReset}
            onIncrement={this.handleIncrement}
            onDelete={this.handleDelete}
          />
        </main>
      </React.Fragment>
    );
  }
}

export default App;
