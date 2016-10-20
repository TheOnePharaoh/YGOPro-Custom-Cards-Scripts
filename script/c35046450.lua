--Vocaloid Kid Miki
function c35046450.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c35046450.splimit)
	c:RegisterEffect(e2)
	--lv change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(35046450,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTarget(c35046450.lvtg)
	e3:SetOperation(c35046450.lvop)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(35046450,2))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c35046450.damcon)
	e4:SetTarget(c35046450.damtg)
	e4:SetOperation(c35046450.damop)
	c:RegisterEffect(e4)
end
function c35046450.splimit(e,c)
	return c:IsSetCard(0xffffff-0x0dac405)
end
function c35046450.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x0dac405)
end
function c35046450.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c35046450.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(35046450,1))
	local lv=Duel.AnnounceNumber(tp,4,5,6,7,8,9)
	e:SetLabel(lv)
end
function c35046450.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c35046450.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c35046450.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_GRAVE)
end
function c35046450.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(2400)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,2400)
end
function c35046450.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end