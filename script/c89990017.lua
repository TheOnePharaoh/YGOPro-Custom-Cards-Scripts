--secret cave
function c89990017.initial_effect(c)
	c:SetUniqueOnField(1,0,89990017)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetTarget(c89990017.infilter)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c89990017.con)
	e3:SetTarget(c89990017.tg)
	e3:SetOperation(c89990017.op)
	c:RegisterEffect(e3)
end
function c89990017.infilter(e,c)
	return c:IsFaceup() and c:IsCode(89990018)
end
function c89990017.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c89990017.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c89990017.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsAbleToDeck() then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
		Duel.Recover(tp,1000,REASON_EFFECT)
	end
end
