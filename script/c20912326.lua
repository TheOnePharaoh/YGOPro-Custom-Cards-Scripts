--Action Card - Infected Sword
function c20912326.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c20912326.target)
	e1:SetOperation(c20912326.activate)
	c:RegisterEffect(e1)
	--activate once on hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20912326,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetOperation(c20912326.spop1)
	c:RegisterEffect(e2)
end
function c20912326.filter(c)
	return c:IsFaceup()
end
function c20912326.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c20912326.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c20912326.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c20912326.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(0)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
function c20912326.spop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if not tc or not tc:IsRelateToEffect(e) then return end
	local tpe=tc:GetType()
	if tc:IsType(TYPE_MONSTER) then
	if tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	else
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
end
	else
	if not tc:IsType(TYPE_FIELD) and Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tpe=tc:GetType()
	local te=tc:GetActivateEffect()
	if not te then
	Duel.Destroy(tc,REASON_EFFECT)
end
	if te then
	local tg=te:GetTarget()
	local co=te:GetCost()
	local op=te:GetOperation()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	Duel.ClearTargetCard()
	if bit.band(tpe,TYPE_FIELD)~=0 then
	local of=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
	if of then Duel.Destroy(of,REASON_RULE) end
	of=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if of and Duel.Destroy(of,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
end
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	Duel.Hint(HINT_CARD,0,tc:GetCode())
	tc:CreateEffectRelation(te)
	if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)==0 then
	tc:CancelToGrave(false)
end
	if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
	if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
	Duel.BreakEffect()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g then
	local etc=g:GetFirst()
	while etc do
	etc:CreateEffectRelation(te)
	etc=g:GetNext()
	end
end
	if op then op(te,tp,eg,ep,ev,re,r,rp) end
	tc:ReleaseEffectRelation(te)
	if etc then
	etc=g:GetFirst()
	while etc do
	etc:ReleaseEffectRelation(te)
	etc=g:GetNext()
	end
end
	else
	Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end