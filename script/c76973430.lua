--Deformity
function c76973430.initial_effect(c)
	c:SetUniqueOnField(1,0,76973430)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--hand limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_HAND_LIMIT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(3)
	c:RegisterEffect(e2)
	--Draw
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PREDRAW)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c76973430.pdraw)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(76973430,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_DRAW)
	e4:SetCondition(c76973430.drcon)
	e4:SetTarget(c76973430.drtg)
	e4:SetOperation(c76973430.drop)
	e4:SetLabelObject(e4)
	c:RegisterEffect(e4)
	--maintain
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetOperation(c76973430.mtop)
	c:RegisterEffect(e5)
end
function c76973430.pdraw(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(ep,LOCATION_HAND,0)==0 then e:SetLabel(1)
	else e:SetLabel(0) end
end
function c76973430.drcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_RULE and e:GetLabelObject():GetLabel()==1
end
function c76973430.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(ep)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,ep,1)
end
function c76973430.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c76973430.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return end
	if Duel.GetLP(tp)>500 and Duel.SelectYesNo(tp,aux.Stringid(76973430,1)) then
		Duel.PayLPCost(tp,800)
	else
		Duel.Destroy(e:GetHandler(),REASON_RULE)
	end
end
