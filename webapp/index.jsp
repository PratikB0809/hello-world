<!doctype html>
<!--
  form-filling.html
  A single-file, accessible, responsive HTML form with client-side validation,
  preview, localStorage save & clear, and example fetch POST to /submit.

  Features:
  - Name, email, phone, password, confirm password
  - Date of birth, gender (radio), skills (checkboxes), experience (range)
  - Country (select), address (textarea), resume upload (file), terms checkbox
  - Client-side validation with helpful messages
  - Live preview of entered data (excluding password)
  - Save/Load to localStorage
  - Example submission via fetch (commented out endpoint)
  - Fully keyboard accessible and mobile responsive
-->
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Form Filling Example</title>
  <style>
    :root{
      --max-width:900px;
      --accent:#0066cc;
      --muted:#666;
      --bg:#f7f9fb;
    }
    body{font-family:Inter, system-ui, -apple-system, 'Segoe UI', Roboto, 'Helvetica Neue', Arial; background:var(--bg); padding:24px; color:#111}
    .container{max-width:var(--max-width); margin:0 auto; background:#fff; border-radius:12px; box-shadow:0 6px 20px rgba(15,23,42,0.08); padding:20px;}
    h1{font-size:1.4rem; margin:0 0 6px}
    p.lead{margin:0 0 18px; color:var(--muted)}
    form{display:grid; grid-template-columns:1fr 320px; gap:20px}
    fieldset{border:1px solid #e6eef8; padding:12px; border-radius:8px}
    .form-row{display:flex; gap:12px}
    label{display:block; font-size:0.9rem; margin-bottom:6px}
    input[type=text], input[type=email], input[type=password], input[type=tel], select, textarea, input[type=date]{width:100%; padding:10px 12px; border-radius:8px; border:1px solid #d6e3f5; box-sizing:border-box}
    textarea{min-height:90px; resize:vertical}
    .helper{font-size:0.8rem; color:var(--muted); margin-top:6px}
    .actions{display:flex; gap:8px; flex-wrap:wrap}
    button{background:var(--accent); color:white; border:none; padding:10px 14px; border-radius:8px; cursor:pointer}
    button.secondary{background:#f3f6fb; color:#111; border:1px solid #d6e3f5}
    .error{color:#b00020; font-size:0.85rem}
    .preview{background:#f8fbff; border:1px dashed #cfe6ff; padding:12px; border-radius:8px}
    .small{font-size:0.9rem}
    .chips{display:flex; gap:6px; flex-wrap:wrap}
    .chip{background:#eef6ff; color:#034; padding:6px 8px; border-radius:999px; font-size:0.85rem}

    /* responsive */
    @media (max-width:900px){
      form{grid-template-columns:1fr;}
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>Example Form — Fill & Preview</h1>
    <p class="lead">A ready-to-use form with validation, preview, and local save. Use this as a template and adapt fields to your needs.</p>

    <form id="mainForm" novalidate>
      <div>
        <fieldset>
          <legend><strong>Personal details</strong></legend>

          <div class="form-row">
            <div style="flex:1">
              <label for="fullName">Full name</label>
              <input type="text" id="fullName" name="fullName" required minlength="2" placeholder="Jane Doe" />
              <div class="error" id="fullNameError" aria-live="polite"></div>
            </div>
            <div style="width:160px">
              <label for="dob">Date of birth</label>
              <input type="date" id="dob" name="dob" />
            </div>
          </div>

          <div style="display:flex; gap:12px; margin-top:12px">
            <div style="flex:1">
              <label for="email">Email</label>
              <input type="email" id="email" name="email" required placeholder="you@example.com" />
              <div class="error" id="emailError" aria-live="polite"></div>
            </div>
            <div style="width:160px">
              <label for="phone">Phone</label>
              <input type="tel" id="phone" name="phone" inputmode="tel" pattern="[0-9+\-() ]{7,}" placeholder="+91 98765 43210" />
            </div>
          </div>

          <div style="display:flex; gap:12px; margin-top:12px">
            <div style="flex:1">
              <label for="password">Password</label>
              <input type="password" id="password" name="password" minlength="8" placeholder="At least 8 characters" />
            </div>
            <div style="flex:1">
              <label for="confirmPassword">Confirm password</label>
              <input type="password" id="confirmPassword" name="confirmPassword" />
            </div>
          </div>

          <div style="margin-top:12px">
            <label>Gender</label>
            <div style="display:flex; gap:12px">
              <label><input type="radio" name="gender" value="male"> Male</label>
              <label><input type="radio" name="gender" value="female"> Female</label>
              <label><input type="radio" name="gender" value="other"> Other</label>
            </div>
          </div>

          <div style="margin-top:12px">
            <label>Skills</label>
            <div style="display:flex; gap:10px; flex-wrap:wrap; margin-top:8px">
              <label><input type="checkbox" name="skills" value="aws"> AWS</label>
              <label><input type="checkbox" name="skills" value="docker"> Docker</label>
              <label><input type="checkbox" name="skills" value="kubernetes"> Kubernetes</label>
              <label><input type="checkbox" name="skills" value="python"> Python</label>
            </div>
          </div>

          <div style="margin-top:12px">
            <label for="experience">Years of experience: <span id="expVal">1</span></label>
            <input type="range" id="experience" name="experience" min="0" max="20" value="1" />
          </div>

          <div style="margin-top:12px">
            <label for="country">Country</label>
            <select id="country" name="country">
              <option value="">Select</option>
              <option>India</option>
              <option>United States</option>
              <option>United Kingdom</option>
              <option>Other</option>
            </select>
          </div>

          <div style="margin-top:12px">
            <label for="address">Address</label>
            <textarea id="address" name="address" placeholder="Street, city, state, postal code"></textarea>
          </div>

          <div style="margin-top:12px">
            <label for="resume">Upload resume (PDF, max 2MB)</label>
            <input type="file" id="resume" name="resume" accept="application/pdf" />
            <div class="helper">Optional — used only for application submission</div>
          </div>

          <div style="margin-top:12px">
            <label><input type="checkbox" id="terms" name="terms" required> I agree to the <a href="#">terms</a></label>
            <div class="error" id="termsError"></div>
          </div>

        </fieldset>

        <div style="margin-top:12px; display:flex; gap:8px; align-items:center">
          <div class="actions">
            <button type="button" id="saveBtn">Save locally</button>
            <button type="button" id="loadBtn" class="secondary">Load saved</button>
            <button type="button" id="clearBtn" class="secondary">Clear saved</button>
          </div>
        </div>

        <div style="margin-top:12px">
          <button type="submit">Submit form</button>
        </div>

      </div>

      <aside>
        <fieldset>
          <legend><strong>Preview</strong></legend>
          <div class="preview" id="preview">No data yet — start filling the form.</div>
        </fieldset>

        <fieldset style="margin-top:12px">
          <legend><strong>Quick tips</strong></legend>
          <ul class="small">
            <li>Use <kbd>Tab</kbd> to move focus; forms are keyboard accessible.</li>
            <li>Passwords are validated client-side — for production, also validate on server.</li>
            <li>Files are not stored in localStorage — only filenames shown in preview.</li>
          </ul>
        </fieldset>
      </aside>

    </form>
  </div>

  <script>
    // Helpers
    const form = document.getElementById('mainForm');
    const preview = document.getElementById('preview');
    const exp = document.getElementById('experience');
    const expVal = document.getElementById('expVal');
    const saveKey = 'sampleFormData_v1';

    exp.addEventListener('input', ()=> expVal.textContent = exp.value);

    function showError(id, msg){
      const el = document.getElementById(id);
      if(el) el.textContent = msg || '';
    }

    function collectFormData(){
      const data = new FormData(form);
      // get checkbox group for skills
      const skills = [];
      form.querySelectorAll('input[name="skills"]:checked').forEach(cb => skills.push(cb.value));

      // get gender
      const gender = form.querySelector('input[name="gender"]:checked')?.value || '';

      // file info (do NOT store raw file in localStorage)
      const resumeInput = document.getElementById('resume');
      const resumeName = resumeInput.files && resumeInput.files.length ? resumeInput.files[0].name : '';

      return {
        fullName: data.get('fullName') || '',
        dob: data.get('dob') || '',
        email: data.get('email') || '',
        phone: data.get('phone') || '',
        gender,
        skills,
        experience: data.get('experience') || '0',
        country: data.get('country') || '',
        address: data.get('address') || '',
        resumeName,
        terms: !!data.get('terms')
      };
    }

    function updatePreview(){
      const d = collectFormData();
      const html = `
        <div><strong>${escapeHtml(d.fullName || '—')}</strong></div>
        <div class="small">${escapeHtml(d.email || '—')} ${d.phone ? '· ' + escapeHtml(d.phone) : ''}</div>
        <div style="margin-top:8px">${d.address ? escapeHtml(d.address) : '<span class=\"small\">No address</span>'}</div>
        <div style="margin-top:8px"><span class=\"small\">DOB:</span> ${d.dob || '—'}</div>
        <div style="margin-top:6px"><span class=\"small\">Gender:</span> ${escapeHtml(d.gender || '—')}</div>
        <div style="margin-top:6px"><span class=\"small\">Skills:</span> ${d.skills.length ? d.skills.map(s=>`<span class=\"chip\">${escapeHtml(s)}</span>`).join(' ') : '<span class=\"small\">None</span>'}</div>
        <div style="margin-top:6px"><span class=\"small\">Experience:</span> ${escapeHtml(d.experience)} years</div>
        <div style="margin-top:6px"><span class=\"small\">Country:</span> ${escapeHtml(d.country || '—')}</div>
        <div style="margin-top:6px"><span class=\"small\">Resume:</span> ${escapeHtml(d.resumeName || 'Not uploaded')}</div>
        <div style="margin-top:8px" class="helper">${d.terms ? 'Agreed to terms' : '<span class=\"error\">Terms not agreed</span>'}</div>
      `;
      preview.innerHTML = html;
    }

    // Basic escape
    function escapeHtml(str){
      if(!str) return '';
      return String(str).replace(/[&<>\"']/g, function(m){return {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":"&#39;"}[m];});
    }

    // Update preview on input changes
    form.addEventListener('input', updatePreview);
    form.addEventListener('change', updatePreview);

    // Save to localStorage
    document.getElementById('saveBtn').addEventListener('click', ()=>{
      const d = collectFormData();
      localStorage.setItem(saveKey, JSON.stringify(d));
      alert('Form saved locally');
    });

    document.getElementById('loadBtn').addEventListener('click', ()=>{
      const raw = localStorage.getItem(saveKey);
      if(!raw){ alert('No saved form found'); return; }
      try{
        const obj = JSON.parse(raw);
        // repopulate fields (note: file inputs cannot be populated programmatically)
        document.getElementById('fullName').value = obj.fullName || '';
        document.getElementById('dob').value = obj.dob || '';
        document.getElementById('email').value = obj.email || '';
        document.getElementById('phone').value = obj.phone || '';
        document.getElementById('experience').value = obj.experience || 1;
        document.getElementById('expVal').textContent = obj.experience || 1;
        document.getElementById('country').value = obj.country || '';
        document.getElementById('address').value = obj.address || '';
        document.getElementById('terms').checked = !!obj.terms;
        // skills
        form.querySelectorAll('input[name="skills"]').forEach(cb => cb.checked = obj.skills?.includes(cb.value));
        // gender
        if(obj.gender){
          const g = form.querySelector(`input[name=\"gender\"][value=\"${obj.gender}\"]`);
          if(g) g.checked = true;
        }
        updatePreview();
        alert('Loaded saved form (files not restored)');
      }catch(e){ console.error(e); alert('Failed to load saved form'); }
    });

    document.getElementById('clearBtn').addEventListener('click', ()=>{
      localStorage.removeItem(saveKey);
      alert('Saved form cleared');
    });

    // Validate before submit
    form.addEventListener('submit', (e)=>{
      e.preventDefault();
      // reset errors
      showError('fullNameError',''); showError('emailError',''); showError('termsError','');

      let valid = true;
      const name = document.getElementById('fullName');
      const email = document.getElementById('email');
      const terms = document.getElementById('terms');
      const pwd = document.getElementById('password');
      const confirmPwd = document.getElementById('confirmPassword');

      if(!name.value || name.value.trim().length < 2){ showError('fullNameError', 'Please enter your name (min 2 chars)'); valid=false; }
      if(!email.value || !/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email.value)){ showError('emailError', 'Please enter a valid email'); valid=false; }
      if(!terms.checked){ showError('termsError', 'You must agree to the terms'); valid=false; }
      if(pwd.value){ if(pwd.value.length < 8){ alert('Password must be at least 8 characters'); valid=false; } }
      if(pwd.value || confirmPwd.value){ if(pwd.value !== confirmPwd.value){ alert('Passwords do not match'); valid=false; } }

      // file size check
      const resumeInput = document.getElementById('resume');
      if(resumeInput.files && resumeInput.files.length){
        const file = resumeInput.files[0];
        if(file.size > 2 * 1024 * 1024){ alert('Resume file exceeds 2MB'); valid=false; }
      }

      if(!valid) { return; }

      // prepare payload (example)
      const payload = collectFormData();

      // In production, you'd send the form and files to your server. Example shown below:
      /*
      const outForm = new FormData();
      outForm.append('fullName', document.getElementById('fullName').value);
      // append file if exists
      if(resumeInput.files && resumeInput.files.length){ outForm.append('resume', resumeInput.files[0]); }
      fetch('/submit', { method: 'POST', body: outForm })
        .then(r => r.json()).then(resp => { alert('Submitted!'); })
        .catch(err => { alert('Submission failed'); console.error(err); });
      */

      // For demo, simply show collected payload in an alert and clear sensitive fields
      alert('Form validated ✔ — ready to send to server. Check console for payload.');
      console.log('Form payload:', payload);
      // clear password fields
      pwd.value = '';
      confirmPwd.value = '';
    });

    // initialize preview
    updatePreview();
  </script>
</body>
</html>

