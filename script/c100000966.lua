 --Created and coded by Rising Phoenix
function c100000966.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100000966+EFFECT_COUNT_CODE_OATH)
	e1:SetDescription(aux.Stringid(100000966,1))
	e1:SetOperation(c100000966.activate)
	c:RegisterEffect(e1)
		-- draw
	local e2=Effect.CreateEffect(c)
	e2:SetCountLimit(1,100000966+EFFECT_COUNT_CODE_OATH)
	e2:SetDescription(aux.Stringid(100000966,2))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCost(c100000966.cost)
	e2:SetTarget(c100000966.target)
	e2:SetOperation(c100000966.operation)
	c:RegisterEffect(e2)
end	
function c100000966.cfilter(c)
	return c:IsSetCard(0x115) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c100000966.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000966.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c100000966.cfilter,1,1,REASON_COST,e:GetHandler())
end
function c100000966.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c100000966.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c100000966.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,100000966)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x115))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,100000966,RESET_PHASE+PHASE_END,0,1)
end