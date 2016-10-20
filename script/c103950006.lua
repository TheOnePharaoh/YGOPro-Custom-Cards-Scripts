--Spectral Necromancy
function c103950006.initial_effect(c)

	--Mono	
	local e1=Effect.CreateEffect(c)	
	e1:SetDescription(aux.Stringid(103950006,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCondition(c103950006.monocon)
	e1:SetOperation(c103950006.monoop)
	c:RegisterEffect(e1)
	
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(103950006,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c103950006.target)
	e2:SetOperation(c103950006.activate)
	c:RegisterEffect(e2)
end
--Mono
function c103950006.monocon(e) return Duel.GetTurnCount()<3 and Duel.GetTurnPlayer()==e:GetHandler():GetControler() end
function c103950006.monofilter(c,g) return g:IsExists(c103950006.monofilter2,1,c,c:GetOriginalCode()) end
function c103950006.monofilter2(c,code) return c:GetOriginalCode() == code end
function c103950006.monoop(e,tp,eg,ep,ev,re,r,rp)
	local location = LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA
	local g=Duel.GetMatchingGroup(nil,tp,location,0,nil)
	if g:IsExists(c103950006.monofilter,1,nil,g) then
		Duel.Win(1-tp, nil)
	end
end
--Filter for card in grave
function c103950006.gravefilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
--Filter for banished
function c103950006.banishedfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
--Target
function c103950006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return
		Duel.IsExistingTarget(c103950006.gravefilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
		and Duel.IsExistingTarget(c103950006.banishedfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c103950006.gravefilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(103950006,3))
	local g2=Duel.SelectTarget(tp,c103950006.banishedfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g2,1,0,0)
	e:SetLabelObject(g1:GetFirst())
end
--Activate
function c103950006.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc1,tc2=Duel.GetFirstTarget()
	if tc1~=e:GetLabelObject() then tc1,tc2=tc2,tc1 end
	if tc1:IsRelateToEffect(e) and c103950006.gravefilter(tc1) and
	   tc2:IsRelateToEffect(e) and c103950006.banishedfilter(tc1) then
		Duel.Remove(tc1,POS_FACEUP,REASON_EFFECT)
		Duel.SendtoGrave(tc2,REASON_EFFECT+REASON_RETURN)
		
		if tc1:IsControler(tp) and tc2:IsControler(tp) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end