--The Idol Master of Greed and Fear Ghard
function c59821096.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c59821096.splimit)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE) 
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetCondition(c59821096.atkcon)
	c:RegisterEffect(e2)
	--damage 0
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	c:RegisterEffect(e3)
	--atk and pierce
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(59821096,0))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCondition(c59821096.condition)
	e4:SetTarget(c59821096.target)
	e4:SetOperation(c59821096.operation)
	c:RegisterEffect(e4)
	--atk up
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(c59821096.tg)
	e5:SetValue(300)
	c:RegisterEffect(e5)
	--splimit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetTargetRange(1,0)
	e6:SetTarget(c59821096.splimit2)
	e6:SetCondition(c59821096.splimcon)
	c:RegisterEffect(e6)
	--destroy
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_RELEASE+CATEGORY_DESTROY)
	e7:SetDescription(aux.Stringid(59821096,1))
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetCondition(c59821096.descon)
	e7:SetTarget(c59821096.destg)
	e7:SetOperation(c59821096.desop)
	c:RegisterEffect(e7)
end
function c59821096.splimit2(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xa1a2) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c59821096.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c59821096.tg(e,c)
	return c:IsSetCard(0xa1a2) or c:IsCode(59821039) or c:IsCode(59821040) or c:IsCode(59821041) or c:IsCode(59821042) or c:IsCode(59821043) or c:IsCode(59821044) or c:IsCode(59821045) or c:IsCode(59821046) or c:IsCode(59821048) or c:IsCode(59821049)
end
function c59821096.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c59821096.filter2(c)
	return c:IsSetCard(0xa1a2) and not c:IsCode(59821096) and c:IsFaceup()
end
function c59821096.atkcon(e,tp,eg,ep,ev,re,r,rp)
    local tp=e:GetHandlerPlayer()
	return not Duel.IsExistingMatchingCard(c59821096.filter2,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c59821096.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c59821096.perfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa1a2) and c:IsType(TYPE_MONSTER) and not c:IsCode(59821096)
end
function c59821096.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c59821096.perfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c59821096.perfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c59821096.perfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c59821096.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(800)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_PIERCE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c59821096.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c59821096.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsLocation(LOCATION_DECK) end
	if not Duel.CheckReleaseGroup(tp,nil,1,nil) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	end
end
function c59821096.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	if Duel.CheckReleaseGroup(tp,Card.IsReleasableByEffect,1,c) and Duel.SelectYesNo(tp,aux.Stringid(59821096,2)) then
		local g=Duel.SelectReleaseGroup(tp,Card.IsReleasableByEffect,1,1,c)
		Duel.Release(g,REASON_EFFECT)
	else Duel.Destroy(c,REASON_EFFECT) end
end