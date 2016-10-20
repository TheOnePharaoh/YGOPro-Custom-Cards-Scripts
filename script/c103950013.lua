--Mystical Maesltrom
function c103950013.initial_effect(c)

	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	--Destruction
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(103950013,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c103950013.descon)
	e2:SetTarget(c103950013.destg)
	e2:SetOperation(c103950013.desop)
	c:RegisterEffect(e2)
	
	--Draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(103950013,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c103950013.drcon)
	e3:SetCost(c103950013.drcost)
	e3:SetTarget(c103950013.drtg)
	e3:SetOperation(c103950013.drop)
	c:RegisterEffect(e3)
end

--Destruction filter
function c103950013.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup()
end
--Destruction condition
function c103950013.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp 
		and e:GetHandler():IsFaceup()
		and Duel.IsExistingMatchingCard(c103950013.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
--Destruction target
function c103950013.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() and c103950013.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c103950013.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c103950013.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
--Destruction operation
function c103950013.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c103950013.desfilter(tc) and tc:IsDestructable() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

--Draw condition
function c103950013.drcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_DESTROY)~=0
		and bit.band(e:GetHandler():GetPreviousLocation(),LOCATION_ONFIELD)~=0
		and bit.band(e:GetHandler():GetPreviousPosition(),POS_FACEUP)~=0
end
--Draw cost
function c103950013.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,103950013)==0 end
	Duel.RegisterFlagEffect(tp,103950013,RESET_PHASE+PHASE_END,0,1)
end
--Draw target
function c103950013.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
--Draw operation
function c103950013.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end