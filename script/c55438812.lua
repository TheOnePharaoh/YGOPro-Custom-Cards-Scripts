--God's Realm
function c55438812.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetCondition(c55438812.tokcon)
	e2:SetTarget(c55438812.toktg)
	e2:SetOperation(c55438812.tokop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_HAND+LOCATION_GRAVE,0)
	e3:SetTarget(c55438812.efftg)
	e3:SetCode(55438812)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(55438812,0))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,55438812)
	e4:SetCost(c55438812.drcost)
	e4:SetTarget(c55438812.drtg)
	e4:SetOperation(c55438812.drop)
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(55438812,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1,55438812)
	e5:SetCost(c55438812.spcost)
	e5:SetTarget(c55438812.sptg)
	e5:SetOperation(c55438812.spop)
	c:RegisterEffect(e5)
	--remove
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e6:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(0xff,0xff)
	e6:SetCondition(c55438812.rmcon)
	e6:SetTarget(c55438812.rmtarget)
	e6:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e6)
end
function c55438812.removfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd70)
end
function c55438812.rmcon(e)
	return Duel.IsExistingMatchingCard(c55438812.removfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c55438812.rmtarget(e,c)
	return not c:IsSetCard(0xd70)
end
function c55438812.tokcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c55438812.toktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,55438816,0xd70,0x4011,1000,1000,3,RACE_FAIRY,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c55438812.tokop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e)
		or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,55438816,0xd70,0x4011,1000,1000,3,RACE_FAIRY,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,55438816)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c55438812.efftg(e,c)
	return c:IsSetCard(0xd70)
end
function c55438812.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,nil,2,nil) end
	local sg=Duel.SelectReleaseGroup(tp,nil,2,2,nil)
	Duel.Release(sg,REASON_COST)
end
function c55438812.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c55438812.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c55438812.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_COST+REASON_DISCARD)
end
function c55438812.spfilter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xd70) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c55438812.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_EXTRA) and chkc:IsControler(tp) and c55438812.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c55438812.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c55438812.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c55438812.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP) then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0xfe0000)
	tc:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+0xfe0000)
	tc:RegisterEffect(e2,true)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SET_ATTACK)
	e3:SetValue(3000)
	e3:SetReset(RESET_EVENT+0xfe0000)
	tc:RegisterEffect(e3,true)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SET_DEFENSE)
	e4:SetValue(3000)
	e4:SetReset(RESET_EVENT+0xfe0000)
	tc:RegisterEffect(e4,true)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetOperation(c55438812.desop)
	e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e5:SetCountLimit(1)
	tc:RegisterEffect(e5,true)
	Duel.SpecialSummonComplete()
	end
end
function c55438812.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end