import { useEffect, useState } from 'react';
import { Button, SafeAreaView, StyleSheet, Text, View } from 'react-native';
import MarfeelTracker from 'react-native-marfeel-tracker';

const ACCOUNT_ID = '123456';
const HOME_URL = 'https://german.borto.li';

export default function App() {
  const [userId, setUserId] = useState('');

  useEffect(() => {
    MarfeelTracker.initialize(ACCOUNT_ID);
    MarfeelTracker.trackPage(HOME_URL);
    MarfeelTracker.setLandingPage(HOME_URL);

    setUserId(MarfeelTracker.getUserId());
  }, []);

  const handleClick = () => {
    MarfeelTracker.trackClick('cta.primary');
  };

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.section}>
        <Text style={styles.title}>Marfeel Tracker Demo</Text>
        <Text selectable>Account: {ACCOUNT_ID}</Text>
        <Text selectable>User ID: {userId || 'pending'}</Text>
      </View>

      <View style={styles.section}>
        <Button title="Track CTA click" onPress={handleClick} />
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 24,
    justifyContent: 'center',
    backgroundColor: '#f5f5f5',
  },
  section: {
    marginBottom: 24,
    alignItems: 'center',
  },
  title: {
    fontSize: 18,
    fontWeight: '600',
    marginBottom: 8,
  },
});
