--Mechquipped Hammerman
function c19007846.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c19007846.atktg)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c19007846.atktg)
	e3:SetValue(300)
	c:RegisterEffect(e3)
	--position
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetCode(EVENT_CHANGE_POS)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c19007846.setcon)
	e4:SetTarget(c19007846.settg)
	e4:SetOperation(c19007846.setop)
	c:RegisterEffect(e4)
	--negate attack
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(19007846,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BE_BATTLE_TARGET)
	e5:SetCountLimit(1)
	e5:SetTarget(c19007846.natg)
	e5:SetOperation(c19007846.naop)
	c:RegisterEffect(e5)
	--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_CHANGE_POS)
	e6:SetCountLimit(1,19007846)
	e6:SetCondition(c19007846.poscon)
	e6:SetTarget(c19007846.thtg)
	e6:SetOperation(c19007846.thop)
	c:RegisterEffect(e6)
end
function c19007846.atktg(e,c)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c19007846.cfilter(c)
	local np=c:GetPosition()
	local pp=c:GetPreviousPosition()
	return c:IsSetCard(0xda3791) or c:IsSetCard(0xda3790) or c:IsCode(15914410) or c:IsCode(41309158) and ((pp==0x1 and np==0x4) or (pp==0x4 and np==0x1) or (pp==0x8 and np==0x1))
end
function c19007846.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c19007846.cfilter,1,nil)
end
function c19007846.setfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c19007846.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c19007846.setfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c19007846.setfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c19007846.setfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c19007846.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
function c19007846.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xda3791) or c:IsSetCard(0xda3790) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c19007846.natg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c19007846.naop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateAttack() and c:IsRelateToEffect(e) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local g=Duel.GetMatchingGroup(c19007846.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(19007846,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g1=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c19007846.poscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetPreviousPosition(),POS_DEFENSE)~=0 and c:IsFaceup() and c:IsAttackPos() or bit.band(c:GetPreviousPosition(),POS_ATTACK)~=0 and c:IsFaceup() and c:IsDefensePos()
end
function c19007846.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:IsAbleToHand() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c19007846.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
