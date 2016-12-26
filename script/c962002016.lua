--Toon Machina Fortress
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local scard=_G[str]
	local s_id=tonumber(string.sub(str,2))
	return scard,s_id
end

local scard,s_id=getID()

function scard.initial_effect(c)
	if not scard.reg then
	scard.reg=true
	end
	--cannot attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(scard.atklimit)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(scard.sdescon)
	e4:SetOperation(scard.sdesop)
	c:RegisterEffect(e4)
	--direct attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DIRECT_ATTACK)
	e5:SetCondition(scard.dircon)
	c:RegisterEffect(e5)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_SPSUMMON_PROC)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e6:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e6:SetCondition(scard.spcon)
	e6:SetOperation(scard.spop)
	c:RegisterEffect(e6)
	--destroy
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(5556499,0))
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCode(EVENT_BATTLE_DESTROYED)
	e7:SetCondition(scard.condition)
	e7:SetTarget(scard.target)
	e7:SetOperation(scard.operation)
	c:RegisterEffect(e7)
	--handes
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EVENT_CHAIN_SOLVING)
	e8:SetOperation(scard.hdop)
	c:RegisterEffect(e8)
end
function scard.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function scard.sfilter(c)
	return c:IsReason(REASON_DESTROY) and c:IsCode(15259703) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function scard.sdescon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(scard.sfilter,1,nil)
end
function scard.sdesop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function scard.dirfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function scard.dirfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function scard.dircon(e)
	return Duel.IsExistingMatchingCard(scard.dirfilter1,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(scard.dirfilter2,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function scard.spfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsDiscardable()
end
function scard.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
	local g=Duel.GetMatchingGroup(scard.spfilter,tp,LOCATION_HAND,0,nil)
	if not c:IsAbleToGraveAsCost() then
		g:RemoveCard(c)
	end
	return g:CheckWithSumGreater(Card.GetLevel,8)
end
function scard.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(scard.spfilter,c:GetControler(),LOCATION_HAND,0,nil)
	if not c:IsAbleToGraveAsCost() then
		g:RemoveCard(c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local sg=g:SelectWithSumGreater(tp,Card.GetLevel,8)
	Duel.SendtoGrave(sg,REASON_COST+REASON_DISCARD)
end
function scard.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_BATTLE)
end
function scard.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsDestructable() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function scard.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function scard.hdop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	if not re:IsActiveType(TYPE_EFFECT) or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if g and g:IsContains(e:GetHandler()) then
		local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if hg:GetCount()==0 then return end
		Duel.ConfirmCards(tp,hg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local sg=hg:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		Duel.ShuffleHand(1-tp)
	end
end