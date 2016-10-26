--Aetherial Hellformation
function c77777794.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c77777794.target)
	e1:SetOperation(c77777794.activate)
	c:RegisterEffect(e1)
end


function c77777794.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x144)
end
function c77777794.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x3e7)
end
function c77777794.filter3(c)
	return c:IsFaceup() and c:IsSetCard(0x407)
end
function c77777794.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(c77777794.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(c77777794.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g3=Duel.GetMatchingGroup(c77777794.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local ct=0
	if g1:GetCount()>0 then ct=ct+1 end
	if g2:GetCount()>0 then ct=ct+1 end
	if g3:GetCount()>0 then ct=ct+1 end
	if chk==0 then return ct>0 end
	local trk=0
	if g1:GetCount()>0 then trk=trk+1 end
	if g2:GetCount()>0 then trk=trk+2 end
	if g3:GetCount()>0 then trk=trk+5 end
	if not Duel.IsExistingMatchingCard(c77777794.desfilter,tp,0,LOCATION_ONFIELD,1,nil) and trk==8 then
		trk=trk-5
	end
	if not Duel.IsExistingMatchingCard(c77777794.thfilter,tp,LOCATION_DECK,0,1,nil) and trk>=3 and trk~=5 then
		if trk<5 then
			trk=trk-2
		else
			trk=trk-5
		end
	end
	local op=0
	if trk==1 then op=0
	elseif trk==2 then op=0
	elseif trk==3 then op=Duel.SelectOption(tp,aux.Stringid(77777794,0),aux.Stringid(77777794,1))
	elseif trk==5 then op=0
	elseif trk==6 then op=Duel.SelectOption(tp,aux.Stringid(77777794,0),aux.Stringid(77777794,1))
	elseif trk==7 then op=Duel.SelectOption(tp,aux.Stringid(77777794,0),aux.Stringid(77777794,1))
	elseif trk==8 then op=Duel.SelectOption(tp,aux.Stringid(77777794,0),aux.Stringid(77777794,1),aux.Stringid(77777794,2))
	end
	if op==0 then 
		e:SetCategory(CATEGORY_RECOVER)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(2000)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
	elseif op==1 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif op==2 then
		local g=Duel.GetMatchingGroup(c77777794.desfilter,tp,0,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	end
	e:SetLabel(op)
end
function c77777794.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then 
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Recover(p,d,REASON_EFFECT)
	elseif op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c77777794.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif op==2 then
		local g=Duel.GetMatchingGroup(c77777794.desfilter,tp,0,LOCATION_ONFIELD,nil)
		if Duel.Destroy(g,REASON_EFFECT)~=0 then
			Duel.SetTargetPlayer(tp)
			Duel.SetTargetParam(1)
			Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
			if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
			local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
			Duel.Draw(p,d,REASON_EFFECT)
		end
	end
end

function c77777794.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end

function c77777794.thfilter(c)
	return (c:IsSetCard(0x144)or c:IsSetCard(0x3e7)or c:IsSetCard(0x407)) and c:IsType(TYPE_MONSTER)and c:IsAbleToHand()
end