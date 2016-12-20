--Aetherial Girl Hikari
function c66666603.initial_effect(c)
    --pendulum summon
	aux.EnablePendulumAttribute(c)
	--attack twice
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(c66666603.damcon)
	e3:SetTarget(c66666603.damtg)
	e3:SetOperation(c66666603.damop)
	c:RegisterEffect(e3)
	--attribute change - dark to light
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(66666603,0))
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c66666603.target1)
	e4:SetOperation(c66666603.operation1)
	c:RegisterEffect(e4)
	--attribute change - light to dark
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(66666603,1))
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c66666603.target2)
	e5:SetOperation(c66666603.operation2)
	c:RegisterEffect(e5)
	--cannot direct attack
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	c:RegisterEffect(e8)
	--splimit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,0)
	e6:SetTarget(c66666603.splimit)
	c:RegisterEffect(e6)
end

function c66666603.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsRace(RACE_SPELLCASTER) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c66666603.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c66666603.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c66666603.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Damage(p,500,REASON_EFFECT)
end

function c66666603.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x144) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c66666603.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c66666603.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66666603.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c66666603.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	e:SetLabel(rc)
end
function c66666603.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(ATTRIBUTE_LIGHT)
		tc:RegisterEffect(e1)
	end
end
function c66666603.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x144) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c66666603.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c66666603.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66666603.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c66666603.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	e:SetLabel(rc)
end
function c66666603.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(ATTRIBUTE_DARK)
		tc:RegisterEffect(e1)
	end
end
