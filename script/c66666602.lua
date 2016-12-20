--Aetherial Girl Jasmine
function c66666602.initial_effect(c)
    --pendulum summon
	aux.EnablePendulumAttribute(c)
	--lvchange
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66666602,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c66666602.lvtg)
	e2:SetOperation(c66666602.lvop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(66666602,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c66666602.descon)
	e3:SetTarget(c66666602.destg)
	e3:SetOperation(c66666602.desop)
	c:RegisterEffect(e3)
	--atkIncrease
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(66666602,2))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c66666602.cost)
	e4:SetTarget(c66666602.target)
	e4:SetOperation(c66666602.operation)
	c:RegisterEffect(e4)
	--splimit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,0)
	e6:SetTarget(c66666602.splimit)
	c:RegisterEffect(e6)
end

function c66666602.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsRace(RACE_SPELLCASTER) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

function c66666602.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c66666602.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x144)
end
function c66666602.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c66666602.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66666602.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c66666602.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c66666602.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c66666602.filter(tc) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(600)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end



function c66666602.lvfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x144) and c:GetLevel()>0
end
function c66666602.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c66666602.lvfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66666602.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c66666602.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c66666602.lvfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x144) and not c:IsType(TYPE_XYZ)
end
function c66666602.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(c66666602.lvfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,tc)
	local lc=g:GetFirst()
	local lv=tc:GetLevel()
	while lc~=nil do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		lc:RegisterEffect(e1)
		lc=g:GetNext()
	end
end

function c66666602.descon(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	return c:IsAttackAbove(1000)
end
function c66666602.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c66666602.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsAttackAbove(1000) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
		local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-1000)
			c:RegisterEffect(e1)
	end
end
