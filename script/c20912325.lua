--Action Card - Executioner's Sword
function c20912325.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c20912325.target)
	e1:SetOperation(c20912325.activate)
	c:RegisterEffect(e1)
	--activate once on hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20912325,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetOperation(c20912325.spop1)
	c:RegisterEffect(e2)
end
function c20912325.filter(c)
	return c:IsFaceup()
end
function c20912325.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20912325.filter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c20912325.filter,tp,LOCATION_MZONE,0,nil)
	local tg=g:GetMaxGroup(Card.GetAttack)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function c20912325.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c20912325.filter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		local tg=g:GetMaxGroup(Card.GetAttack)
		if tg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=tg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.Destroy(sg,REASON_EFFECT)
		else Duel.Destroy(tg,REASON_EFFECT) end
	end
end
function c20912325.spop1(e,tp,eg,ep,ev,re,r,rp)
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