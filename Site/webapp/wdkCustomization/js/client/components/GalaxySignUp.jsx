import { PropTypes } from 'react';
import GalaxyPageLayout from './GalaxyPageLayout';

/**
 * Sign up page
 */
export default function GalaxySignUp(props) {
  let { onGalaxyNavigate, securityAgreementStatus, updateSecurityAgreementStatus } = props;
  return (
    <GalaxyPageLayout>
      <p>
        The first time you visit EuPathDB Galaxy you will be asked to sign up with Globus, EuPathDB’s Galaxy manager,
        in order to set up your private Galaxy workspace. This is a three-step sign-up process (screenshots below),
        which will be opened in a new tab.
      </p>

      <p>
        <a href="contact-us">Contact us</a> if you experience any difficulties.
      </p>

      <div className="eupathdb-GalaxySignUpScreens">
        <div>
          <div className="eupathdb-GalaxySignUpScreenHeader">
            <strong>1. Create new or link existing Globus account.</strong>
          </div>
          <img title="Option to link an existing Globus Account" src="/a/wdkCustomization/images/globus-02-link-account.jpg"/>
          <div className="eupathdb-GalaxySignUpScreenCaption">
            If you already have a Globus account, you may choose to link it to
            your EuPathDB account. If you don't have an existing Globus account,
            choose <strong>No thanks, continue</strong>.
          </div>
        </div>
        <div>
          <div className="eupathdb-GalaxySignUpScreenHeader">
            <strong>2. Register your credentials.</strong>
          </div>
          <img title="Agree to Globus account terms" src="/a/wdkCustomization/images/globus-03-account-terms.jpg"/>
          <div className="eupathdb-GalaxySignUpScreenCaption">
            Tell Globus how you will use your account, read and agree to their
            Terms and Conditions, then click <strong>Continue</strong>
          </div>
        </div>
        <div>
          <div className="eupathdb-GalaxySignUpScreenHeader">
            <strong>3. Grant EuPathDB Galaxy access to your account.</strong>
          </div>
          <img title="Grant permission to access your Globus account" src="/a/wdkCustomization/images/globus-04-oauth-perms.jpg"/>
          <div className="eupathdb-GalaxySignUpScreenCaption">
            Click <strong>Allow</strong> to grant permission to share the
            account with us. We will only perform file transfers that you explicitly request.
          </div>
        </div>
      </div>

      <div className="eupathdb-GalaxyTermsContinueLink">
        <button
          className="eupathdb-BigButton"
          onClick={onGalaxyNavigate}
          disabled={!securityAgreementStatus}
        >Continue to Galaxy</button>
        <p style={{ fontSize: 'small' }}>
          <label>
            <input
              type="checkbox"
              checked={securityAgreementStatus}
              onClick={e => updateSecurityAgreementStatus(e.target.checked)}
            /> I agree to security terms. <strong style={{color: 'red' }}>TODO</strong>
          </label>
        </p>
      </div>
    </GalaxyPageLayout>
  );
}

GalaxySignUp.propTypes = {
  onGalaxyNavigate: PropTypes.func.isRequired,
  updateSecurityAgreementStatus: PropTypes.func.isRequired,
  securityAgreementStatus: PropTypes.bool.isRequired
};
