--Izanos the Beginning, 9th Arian Guardian
function c77790006.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--change atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c77790006.ufilter)
	e2:SetValue(700)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77790006,0))
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCost(c77790006.cost)
	e4:SetTarget(c77790006.target)
	e4:SetOperation(c77790006.operation)
	c:RegisterEffect(e4)
	--increase scales
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetProperty(EFFECT_FLAG_REPEAT)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCondition(c77790006.slcon)
	e5:SetOperation(c77790006.slop)
	c:RegisterEffect(e5)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(77790006,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(c77790006.tg)
	e6:SetOperation(c77790006.op)
	c:RegisterEffect(e6)
	--negate attack
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_BE_BATTLE_TARGET)
	e7:SetCountLimit(1)
	e7:SetRange(LOCATION_MZONE)
	e7:SetProperty(EFFECT_FLAG_REPEAT)
	e7:SetTarget(c77790006.target2)
	e7:SetOperation(c77790006.operation2)
	c:RegisterEffect(e7)
end
function c77790006.ufilter(e,c)
	return c:IsSetCard(0x100f)
end
function c77790006.costfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c77790006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77790006.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c77790006.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c77790006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c77790006.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
	end
end
function c77790006.slcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp 
end
function c77790006.slop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LSCALE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e2)
	Duel.RaiseSingleEvent(c,EVENT_SCALE_UP,e,0,0,0,0,0)
end
function c77790006.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:GetLevel()<=9 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c77790006.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c77790006.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c77790006.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-c:GetAttack()/2)
	if not c:RegisterEffect(e1) then return end
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft1<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77790006.filter,tp,LOCATION_HAND,0,ft1,ft1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			tc=g:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end
function c77790006.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() and e:GetHandler():GetAttack()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c77790006.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,tp,REASON_EFFECT) then
		Duel.BreakEffect()
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e1:SetRange(LOCATION_HAND)
		e1:SetCountLimit(1)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetOperation(c77790006.summon)
		c:RegisterEffect(e1)
	end
end
function c77790006.summon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
		e1:SetValue(0)
		c:RegisterEffect(e1)
	end
end
