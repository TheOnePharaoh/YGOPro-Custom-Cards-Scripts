--Toon Megurine Luka
function c57888890.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c57888890.spcon)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c57888890.atklimit)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--recover
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(57888890,0))
	e5:SetCategory(CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCountLimit(1)
	e5:SetCondition(c57888890.reccon)
	e5:SetTarget(c57888890.rectg)
	e5:SetOperation(c57888890.recop)
	c:RegisterEffect(e5)
	--direct attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_DIRECT_ATTACK)
	e6:SetCondition(c57888890.dircon)
	c:RegisterEffect(e6)
end
function c57888890.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c57888890.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c57888890.reccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c57888890.recfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c57888890.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetMatchingGroupCount(c57888890.recfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct*500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*500)
end
function c57888890.recop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c57888890.recfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Recover(tp,ct*500,REASON_EFFECT)
end
function c57888890.cfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c57888890.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c57888890.dircon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c57888890.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(c57888890.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end