--Roku Chounen to Ichiya Monogatari - Song of Despair and Emptiness
function c90139918.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,0x1c0+TIMING_END_PHASE)
	e1:SetCountLimit(1,90139918+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c90139918.target)
	e1:SetOperation(c90139918.activate)
	c:RegisterEffect(e1)
end
function c90139918.filter(c,e,tp)
	return c:IsSetCard(0x0dac402) and c:IsType(TYPE_SYNCHRO) and c:IsPosition(POS_FACEUP_ATTACK) and c:IsAttackBelow(2500)
end
function c90139918.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c90139918.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c90139918.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUPATTACK)
	Duel.SelectTarget(tp,c90139918.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c90139918.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.Draw(tp,1,REASON_EFFECT)~=0 and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e2)		
	end
end
