--Arcana Force XIII The Death
function c123208.initial_effect(c)
	-- coin 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(123208,0))
	e1:SetCategory(CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c123208.cointg)
	e1:SetOperation(c123208.coinop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--banish
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e4:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e4)
end
function c123208.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c123208.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local res=0
	if c:IsHasEffect(73206827) then
		res=1-Duel.SelectOption(tp,60,61)
	else res=Duel.TossCoin(tp,1) end
	c123208.arcanareg(c,res)
end
function c123208.arcanareg(c,coin)
	--coin effect 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c123208.atk)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
end
function c123208.atkup(e,c)
	if e:GetHandler():GetFlagEffectLabel(36690018)==1 then
		return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),LOCATION_GRAVE,0,nil,TYPE_MONSTER)*300
	else
		return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),0,LOCATION_GRAVE,nil,TYPE_MONSTER)*-300
	end
end
