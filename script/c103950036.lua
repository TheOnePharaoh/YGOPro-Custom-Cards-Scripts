--Knowledge Mirror
function c103950036.initial_effect(c)
	
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103950036,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c103950036.activatecon)
	e1:SetCost(c103950036.activatecost)
	e1:SetOperation(c103950036.activate)
	c:RegisterEffect(e1)
end

--Activate condition
function c103950036.activatecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,48256875) == 0 and Duel.GetFlagEffect(1-tp,48256875) == 0 
end

--Activate cost
function c103950036.activatecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.RegisterFlagEffect(tp,48256875,RESET_PHASE+PHASE_END,0,1)
end

--Activate operation
function c103950036.activate(e,tp,eg,ep,ev,re,r,rp)
	
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(103950036,1))
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCondition(c103950036.negcon)
	e1:SetOperation(c103950036.negop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	
	--Draw cards
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetDescription(aux.Stringid(103950036,2))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetCountLimit(1)
	e2:SetCondition(c103950036.drawcon)
	e2:SetOperation(c103950036.drawop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end

--Negate match
function c103950036.negmatch(ev)
	
	local ex1,cg1,cc1,cp1,cv1=Duel.GetOperationInfo(ev,CATEGORY_DRAW)
	if ex1 and ((cg1 and cg1:GetCount()>0) or (cv1 and cv1>0)) then return true end
	
	local ex2,cg2,cc2,cp2,cv2=Duel.GetOperationInfo(ev,CATEGORY_TOHAND)
	if ex2 and ((cg2 and cg2:GetCount()>0) or (cv2 and cv2>0)) then return true end
	
	return false
end

--Negate condition
function c103950036.negcon(e,tp,eg,ep,ev,re,r,rp)	
	return not re:GetHandler():IsCode(103950036) and c103950036.negmatch(ev)
end
	
--Negate operation
function c103950036.negop(e,tp,eg,ep,ev,re,r,rp)
	
	if Duel.IsChainDisablable(ev) then
		Duel.NegateEffect(ev)
		Duel.RegisterFlagEffect(tp,103950036,RESET_PHASE+PHASE_END,0,Duel.GetFlagEffect(tp,103950036)+1)
	end
end

--Negate condition
function c103950036.drawcon(e,tp,eg,ep,ev,re,r,rp)	
	return Duel.GetFlagEffect(tp,103950036) > 0
end

--Draw operation
function c103950036.drawop(e,tp,eg,ep,ev,re,r,rp)

	local ct = Duel.GetFlagEffect(tp,103950036)
	
	Duel.Draw(tp,ct,REASON_EFFECT)
	Duel.Draw(1-tp,ct,REASON_EFFECT)
end
