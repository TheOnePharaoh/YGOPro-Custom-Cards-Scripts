--Emergency Re-Adjustment
function c74140841.initial_effect(c)
	--negate attack
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c74140841.condition)
	e1:SetOperation(c74140841.activate)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(74140841,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c74140841.negcon)
	e2:SetCost(c74140841.negcost)
	e2:SetTarget(c74140841.negtg)
	e2:SetOperation(c74140841.negop)
	c:RegisterEffect(e2)
end
function c74140841.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	return not Duel.GetAttacker():IsControler(tp) and tc and tc:IsFaceup() and tc:IsControler(tp) and tc:IsSetCard(0x0dac402) and tc:IsType(TYPE_SYNCHRO)
end
function c74140841.fil1(c,e,tp,lv)
	return c:IsType(TYPE_TUNER) and c:IsSetCard(0x0dac405) and c:IsAbleToRemove() and Duel.IsExistingMatchingCard(c74140841.fil2,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv+c:GetLevel())
end
function c74140841.fil2(c,e,tp,lv)
	return c:IsType(TYPE_SYNCHRO) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c74140841.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateAttack() then return end
	local sc=Duel.GetAttackTarget()
	if sc and sc:IsLocation(LOCATION_MZONE) and sc:IsAbleToRemove() and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c74140841.fil1,tp,LOCATION_GRAVE,0,1,nil,e,tp,sc:GetLevel()) and Duel.SelectYesNo(tp,aux.Stringid(74140841,0)) then
		Duel.BreakEffect()
		local sl=sc:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tg=Duel.SelectMatchingCard(tp,c74140841.fil1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,sl)
		if tg:GetCount()==0 then return end
		local tc=tg:GetFirst()
		sl=sl+tc:GetLevel()
		local rg=Group.FromCards(sc,tc)
		if Duel.Remove(rg,nil,REASON_EFFECT)==2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c74140841.fil2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,sl)
			if g:GetCount()==0 then return end
			Duel.SpecialSummon(g,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
			g:GetFirst():CompleteProcedure()
		end
	end
end
function c74140841.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c74140841.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c74140841.negfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c74140841.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c74140841.negfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c74140841.negfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c74140841.negfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c74140841.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled() and tc:IsControler(1-tp) and tc:IsType(TYPE_EFFECT) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
		end
end