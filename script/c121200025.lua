--End.Catalog Record #2 『M』
--  By Shad3

local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local scard=_G[str]
	local s_id=tonumber(string.sub(str,2))
	return scard,s_id
end

local scard,s_id=getID()

function scard.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--MP/BP
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e2:SetCountLimit(1)
	e2:SetDescription(aux.Stringid(s_id,0))
	e2:SetTarget(scard.a_tg)
	e2:SetOperation(scard.a_op)
	c:RegisterEffect(e2)
	local e2a=e2:Clone()
	e2a:SetCode(EVENT_PHASE+PHASE_BATTLE)
	c:RegisterEffect(e2a)
	local e2b=e2:Clone()
	e2b:SetCode(EVENT_PHASE+PHASE_END)
	c:RegisterEffect(e2b)
	--EffectMonster
	--Setfromdeck
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetCountLimit(1)
	e3:SetDescription(aux.Stringid(s_id,1))
	e3:SetCondition(scard.efmon)
	e3:SetCost(scard.b_cs)
	e3:SetTarget(scard.b_tg)
	e3:SetOperation(scard.b_op)
	c:RegisterEffect(e3)
end

function scard.efmon(e)
	return e:GetHandler():IsType(TYPE_EFFECT)
end

function scard.a_fil(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToDeck() and Duel.IsExistingTarget(scard.a_fil2,tp,LOCATION_GRAVE,0,1,c,tp)
end

function scard.a_fil2(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0,0x41,900,500,3,RACE_PYRO,ATTRIBUTE_WATER)
end

function scard.a_tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return true end
	if Duel.IsExistingTarget(scard.a_fil,tp,LOCATION_GRAVE,0,1,nil,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectTarget(tp,scard.a_fil,tp,LOCATION_GRAVE,0,1,1,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectTarget(tp,scard.a_fil2,tp,LOCATION_GRAVE,0,1,1,g:GetFirst(),tp)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,tp,LOCATION_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,tp,LOCATION_GRAVE)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,tp,LOCATION_SZONE)
end

function scard.a_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local _,tc1=Duel.GetOperationInfo(0,CATEGORY_TODECK)
	local _,tc=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	if tc1 and tc then
		tc1=tc1:GetFirst()
		tc=tc:GetFirst()
		if tc1:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc1:IsAbleToDeck() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,tc:GetCode(),0,0x41,900,500,3,RACE_PYRO,ATTRIBUTE_WATER) then
			Duel.SendtoDeck(tc1,nil,0,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc1)
			tc:AddMonsterAttribute(TYPE_EFFECT)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_ATTRIBUTE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x47c0000)
			e1:SetValue(ATTRIBUTE_WATER)
			tc:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_ADD_RACE)
			e2:SetValue(RACE_PYRO)
			tc:RegisterEffect(e2,true)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_CHANGE_LEVEL)
			e3:SetValue(3)
			tc:RegisterEffect(e3,true)
			local e4=e1:Clone()
			e4:SetCode(EFFECT_SET_BASE_ATTACK)
			e4:SetValue(900)
			tc:RegisterEffect(e4,true)
			local e5=e1:Clone()
			e5:SetCode(EFFECT_SET_BASE_DEFENSE)
			e5:SetValue(500)
			tc:RegisterEffect(e5,true)
			Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
			tc:AddMonsterAttributeComplete()
			local at=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_SZONE,LOCATION_SZONE,nil)*300
			if at>0 then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetRange(LOCATION_MZONE)
				e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetValue(at)
				tc:RegisterEffect(e1,true)
			end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetRange(LOCATION_MZONE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetDescription(aux.Stringid(s_id,2))
			e1:SetValue(scard.a_imfil)
			tc:RegisterEffect(e1,true)
			Duel.SpecialSummonComplete()
		end
	end
	if not c:IsRelateToEffect(e) then return end
	Duel.SendtoGrave(c,REASON_EFFECT)
end

function scard.a_imfil(e,re)
	return re:IsActiveType(TYPE_MONSTER)
end

function scard.b_fil(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsSSetable()
end

function scard.b_cs(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,1) end
	Duel.DiscardDeck(tp,1,REASON_COST)
end

function scard.b_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re and re:IsActiveType(TYPE_MONSTER) and rp~=tp and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(scard.b_fil,tp,LOCATION_DECK,0,1,nil) end
end

function scard.b_op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local tc=Duel.SelectMatchingCard(tp,scard.b_fil,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if tc then
			Duel.ConfirmCards(1-tp,tc)
			Duel.SSet(tp,tc)
			Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end
	end
	local c=e:GetHandler()
	c:ResetEffect(EFFECT_CHANGE_CODE,RESET_CODE)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(re:GetHandler():GetCode())
	c:RegisterEffect(e1,true)
end
