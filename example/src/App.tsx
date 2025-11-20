import { useEffect, useState } from 'react';
import { Button, SafeAreaView, StyleSheet, Text, View } from 'react-native';
import MarfeelTracker from 'react-native-marfeel-tracker';

const ACCOUNT_ID = '111111';
const HOME_URL = 'https://german.borto.li';
const DEMO_SITE_USER_ID = 'demo-user-123';

export default function App() {
  const [userId, setUserId] = useState('');
  const [userType, setUserType] = useState<'anonymous' | 'logged'>('anonymous');
  const [initializing, setInitializing] = useState(true);

  useEffect(() => {
    let cancelled = false;

    const bootstrap = async () => {
      MarfeelTracker.initialize(ACCOUNT_ID);
      MarfeelTracker.setSiteUserId(DEMO_SITE_USER_ID);
      MarfeelTracker.setUserType('anonymous');
      MarfeelTracker.trackPage(HOME_URL);
      MarfeelTracker.setLandingPage(HOME_URL);

      const refreshUserId = () => {
        const id = MarfeelTracker.getUserId();
        if (cancelled) {
          return;
        }
        if (id) {
          setUserId(id);
          setInitializing(false);
        } else {
          setTimeout(refreshUserId, 500);
        }
      };

      refreshUserId();
    };

    bootstrap();

    return () => {
      cancelled = true;
    };
  }, []);

  const handleClick = (target: string) => {
    MarfeelTracker.trackClick(target);
  };

  const handleToggleUser = () => {
    const nextType = userType === 'anonymous' ? 'logged' : 'anonymous';
    setUserType(nextType);
    MarfeelTracker.setUserType(nextType);
    if (nextType === 'logged') {
      MarfeelTracker.setSiteUserId(`${DEMO_SITE_USER_ID}-logged`);
    } else {
      MarfeelTracker.setSiteUserId(DEMO_SITE_USER_ID);
    }
    setUserId(MarfeelTracker.getUserId());
  };

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.section}>
        <Text style={styles.title}>Marfeel Tracker Demo</Text>
        <Text selectable>Account: {ACCOUNT_ID}</Text>
        <Text selectable>
          User ID: {initializing ? 'pending…' : userId || 'unknown'}
        </Text>
        <Text>User Type: {userType}</Text>
      </View>

      <View style={styles.section}>
        <Button
          title="Track CTA click"
          onPress={() => handleClick('cta.primary')}
        />
      </View>

      <View style={styles.section}>
        <Button
          title={
            userType === 'anonymous'
              ? 'Switch to logged user'
              : 'Switch to anonymous'
          }
          onPress={handleToggleUser}
        />
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
