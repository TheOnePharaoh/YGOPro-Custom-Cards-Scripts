--Toon Ooka Miko
function c57888893.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c57888893.spcon)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c57888893.atklimit)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--summon success
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(57888893,0))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c57888893.drcon)
	e5:SetTarget(c57888893.drtarg)
	e5:SetOperation(c57888893.drop)
	c:RegisterEffect(e5)
	--direct attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_DIRECT_ATTACK)
	e6:SetCondition(c57888893.dircon)
	c:RegisterEffect(e6)
end
function c57888893.spfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON) and c:GetCode()~=57888893
end
function c57888893.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c57888893.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c57888893.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c57888893.confilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c57888893.drcon(e)
	return not Duel.IsExistingMatchingCard(c57888893.confilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function c57888893.drtarg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c57888893.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c57888893.cfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c57888893.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c57888893.dircon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c57888893.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(c57888893.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end